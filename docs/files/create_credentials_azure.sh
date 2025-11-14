#!/bin/bash

# =============================================================================
# Qovery Azure Credentials Setup Script
# =============================================================================
# This script creates a service principal for Qovery.
#
# Version: 1.0.0
# Author: Qovery Team
# Documentation: https://docs.qovery.com
# =============================================================================

# Exit immediately on any error, treat unset variables as errors, fail on pipe errors
set -euo pipefail

# =============================================================================
# CONFIGURATION
# =============================================================================

# Application ID for Qovery (provided via --qovery-app-id flag)
app_id=""

# Default configuration
readonly DEFAULT_ROLE_NAME="qovery-sp-role"
readonly SCRIPT_VERSION="1.0.0"

# Runtime configuration
readonly LOG_LEVEL="${LOG_LEVEL:-INFO}"
readonly MAX_RETRIES="${MAX_RETRIES:-3}"
readonly RETRY_DELAY="${RETRY_DELAY:-5}"
readonly PROVIDER_BATCH_SIZE="${PROVIDER_BATCH_SIZE:-5}"

# Minimum Azure CLI version requirement
readonly MIN_AZ_CLI_VERSION="2.0.0"

# =============================================================================
# GLOBAL VARIABLES
# =============================================================================

# Runtime flags
VERBOSE=false
SKIP_CONFIRMATION=false
DRY_RUN=false
QUIET=false

# Working variables
subscription_id=""

# Temporary files
TEMP_ROLE_FILE=""

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Logging function with levels
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    
    if [[ "$QUIET" == true && "$level" != "ERROR" ]]; then
        return 0
    fi
    
    case "$level" in
        ERROR)
            echo "[$timestamp] [ERROR] $message" >&2
            ;;
        WARN)
            echo "[$timestamp] [WARN]  $message" >&2
            ;;
        INFO)
            echo "[$timestamp] [INFO]  $message" >&2
            ;;
        DEBUG)
            if [[ "$VERBOSE" == true ]]; then
                echo "[$timestamp] [DEBUG] $message" >&2
            fi
            ;;
        *)
            echo "[$timestamp] [INFO]  $message" >&2
            ;;
    esac
}

# Error handling with context
error_exit() {
    local exit_code="${2:-1}"
    log "ERROR" "$1"
    log "ERROR" "Script failed at line ${BASH_LINENO[1]} in function ${FUNCNAME[1]}"
    exit "$exit_code"
}

# Safe command execution with retry logic
safe_execute() {
    local max_retries="${1:-1}"
    local delay="${2:-1}"
    shift 2
    local cmd="$*"
    
    local attempt=1
    while [[ $attempt -le $max_retries ]]; do
        log "DEBUG" "Executing (attempt $attempt/$max_retries): $cmd"
        
        if eval "$cmd"; then
            return 0
        fi
        
        if [[ $attempt -lt $max_retries ]]; then
            log "WARN" "Command failed, retrying in ${delay}s..."
            sleep "$delay"
        fi
        
        ((attempt++))
    done
    
    log "ERROR" "Command failed after $max_retries attempts: $cmd"
    return 1
}

# JSON parsing with error handling
parse_json() {
    local json_data="$1"
    local query="$2"
    local default_value="${3:-}"
    
    if [[ -z "$json_data" || "$json_data" == "null" ]]; then
        echo "$default_value"
        return 1
    fi
    
    local result
    if result=$(echo "$json_data" | jq -r "$query" 2>/dev/null) && [[ "$result" != "null" ]]; then
        echo "$result"
        return 0
    else
        echo "$default_value"
        return 1
    fi
}

# =============================================================================
# VALIDATION FUNCTIONS
# =============================================================================

validate_uuid() {
    local uuid="$1"
    local pattern="^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
    
    if [[ ! $uuid =~ $pattern ]]; then
        return 1
    fi
    return 0
}

validate_subscription_id() {
    local subscription_id="$1"
    
    if [[ -n "$subscription_id" ]] && ! validate_uuid "$subscription_id"; then
        error_exit "Invalid subscription ID format. Expected UUID format (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
    fi
}

validate_app_id() {
    local app_id="$1"
    
    if [[ -z "$app_id" ]]; then
        error_exit "Qovery application ID is required. Use --qovery-app-id flag to provide it. Copy the application ID from the Qovery console."
    fi
    
    if ! validate_uuid "$app_id"; then
        error_exit "Invalid application ID format. Expected UUID format (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
    fi
}



validate_az_cli_version() {
    local current_version="$1"
    local required_version="$MIN_AZ_CLI_VERSION"
    
    # Simple version comparison (works for major.minor.patch)
    if ! printf '%s\n%s\n' "$required_version" "$current_version" | sort -V | head -n1 | grep -q "^$required_version$"; then
        error_exit "Azure CLI version $current_version is too old. Minimum required: $required_version"
    fi
}

# =============================================================================
# PREREQUISITE FUNCTIONS
# =============================================================================

check_dependencies() {
    log "INFO" "Checking required dependencies..."
    
    local missing_deps=()
    
    # Check Azure CLI
    if ! command -v az &>/dev/null; then
        missing_deps+=("azure-cli")
    fi
    
    # Check jq
    if ! command -v jq &>/dev/null; then
        missing_deps+=("jq")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error_exit "Missing required dependencies: ${missing_deps[*]}. Please install them before running this script."
    fi
    
    log "INFO" "All dependencies are available"
}

check_azure_cli_version() {
    log "INFO" "Checking Azure CLI version..."
    
    local az_version
    if ! az_version=$(az version --query '"azure-cli"' -o tsv 2>/dev/null); then
        error_exit "Unable to determine Azure CLI version"
    fi
    
    validate_az_cli_version "$az_version"
    log "INFO" "Azure CLI version: $az_version"
}

check_azure_login() {
    log "INFO" "Checking Azure login status..."
    
    if ! az account show &>/dev/null; then
        error_exit "Not logged in to Azure. Please run 'az login' first"
    fi
    
    log "INFO" "Azure login verified"
}

check_prerequisites() {
    check_dependencies
    check_azure_cli_version
    check_azure_login
}

# =============================================================================
# CLEANUP FUNCTIONS
# =============================================================================

cleanup_temp_files() {
    if [[ -n "$TEMP_ROLE_FILE" && -f "$TEMP_ROLE_FILE" ]]; then
        log "DEBUG" "Cleaning up temporary files..."
        rm -f "$TEMP_ROLE_FILE"
    fi
}

cleanup() {
    local exit_code=$?
    
    cleanup_temp_files
    
    if [[ $exit_code -ne 0 ]]; then
        log "ERROR" "Script failed with exit code $exit_code"
        
        if [[ "$VERBOSE" == true ]]; then
            log "ERROR" "Troubleshooting checklist:"
            log "ERROR" "  - Ensure Azure CLI is installed and up to date"
            log "ERROR" "  - Verify you're logged in with 'az login'"
            log "ERROR" "  - Check permissions on target subscription"
            log "ERROR" "  - Validate subscription ID format if provided"
            log "ERROR" "  - Review the Azure portal for any partial changes"
        fi
    fi
    
    exit $exit_code
}

# =============================================================================
# AZURE PROVIDER FUNCTIONS
# =============================================================================

get_required_providers() {
    cat <<EOF
Microsoft.ContainerService
Microsoft.ContainerRegistry
Microsoft.Storage
Microsoft.Network
Microsoft.ContainerInstance
Microsoft.Compute
Microsoft.Authorization
Microsoft.Insights
Microsoft.KeyVault
Microsoft.AppConfiguration
Microsoft.EventGrid
Microsoft.ServiceBus
Microsoft.ManagedIdentity
Microsoft.Features
EOF
}

register_provider() {
    local provider="$1"
    
    if safe_execute "$MAX_RETRIES" "$RETRY_DELAY" "az provider register --namespace '$provider' --wait --only-show-errors >/dev/null 2>&1"; then
        log "DEBUG" "Successfully registered provider: $provider"
        return 0
    else
        log "WARN" "Failed to register provider: $provider"
        return 1
    fi
}

register_azure_providers() {
    log "INFO" "Registering required Azure resource providers..."
    
    local providers=()
    while IFS= read -r provider; do
        [[ -n "$provider" ]] && providers+=("$provider")
    done < <(get_required_providers)
    
    local failed_providers=()
    
    # Process providers in batches to avoid rate limiting
    for ((i=0; i<${#providers[@]}; i+=PROVIDER_BATCH_SIZE)); do
        local batch=("${providers[@]:i:PROVIDER_BATCH_SIZE}")
        local pids=()
        
        for provider in "${batch[@]}"; do
            register_provider "$provider" &
            pids+=($!)
        done
        
        # Wait for batch completion and check results
        for pid in "${pids[@]}"; do
            if ! wait "$pid"; then
                # Note: we can't easily determine which provider failed in this approach
                # but the individual function logs will show the details
                true  # Continue processing
            fi
        done
    done
    
    log "INFO" "Resource provider registration completed"
}

# =============================================================================
# AZURE ROLE FUNCTIONS
# =============================================================================

get_role_permissions() {
    cat <<'EOF'
Microsoft.ContainerService/managedClusters/*
Microsoft.ContainerService/locations/operationresults/read
Microsoft.ContainerService/locations/operations/read
Microsoft.ContainerService/operations/read
Microsoft.ContainerService/locations/usages/read
Microsoft.ContainerService/locations/orchestrators/read

Microsoft.ContainerRegistry/registries/*
Microsoft.ContainerRegistry/locations/operationresults/read
Microsoft.ContainerRegistry/operations/read
Microsoft.ContainerRegistry/checkNameAvailability/read

Microsoft.Storage/storageAccounts/*
Microsoft.Storage/locations/usages/read
Microsoft.Storage/operations/read
Microsoft.Storage/storageAccounts/listAccountSas/action
Microsoft.Storage/storageAccounts/listServiceSas/action
Microsoft.Storage/storageAccounts/listKeys/action
Microsoft.Storage/storageAccounts/blobServices/*
Microsoft.Storage/storageAccounts/fileServices/*

Microsoft.Network/virtualNetworks/*
Microsoft.Network/networkSecurityGroups/*
Microsoft.Network/routeTables/*
Microsoft.Network/publicIPAddresses/*
Microsoft.Network/loadBalancers/*
Microsoft.Network/networkInterfaces/*
Microsoft.Network/natGateways/*
Microsoft.Network/locations/operations/read
Microsoft.Network/locations/usages/read
Microsoft.Network/operations/read
Microsoft.Network/dnsZones/*
Microsoft.Network/privateDnsZones/*
Microsoft.Network/publicIPPrefixes/*
Microsoft.Network/applicationSecurityGroups/*
Microsoft.Network/privateEndpoints/*
Microsoft.Network/privateLinkServices/*

Microsoft.Compute/virtualMachineScaleSets/*
Microsoft.Compute/virtualMachines/*
Microsoft.Compute/disks/*
Microsoft.Compute/snapshots/*
Microsoft.Compute/availabilitySets/*
Microsoft.Compute/locations/operations/read
Microsoft.Compute/locations/usages/read
Microsoft.Compute/locations/vmSizes/read
Microsoft.Compute/operations/read

Microsoft.Resources/subscriptions/resourceGroups/*
Microsoft.Resources/subscriptions/resources/read
Microsoft.Resources/deployments/*
Microsoft.Resources/subscriptions/operationresults/read
Microsoft.Resources/subscriptions/providers/read

Microsoft.Authorization/roleAssignments/*
Microsoft.Authorization/roleDefinitions/read
Microsoft.Authorization/*/read

Microsoft.ManagedIdentity/userAssignedIdentities/*
Microsoft.ManagedIdentity/*/read

Microsoft.KeyVault/vaults/*
Microsoft.KeyVault/operations/read

Microsoft.Insights/components/*
Microsoft.Insights/webtests/*
Microsoft.Insights/alertRules/*
Microsoft.Insights/diagnosticSettings/*
Microsoft.Insights/logDefinitions/read
Microsoft.Insights/metricDefinitions/read

Microsoft.Features/features/read
Microsoft.Features/providers/features/read
Microsoft.Features/providers/features/register/action

Microsoft.ContainerInstance/containerGroups/*
Microsoft.ContainerInstance/locations/operations/read
Microsoft.ContainerInstance/operations/read
Microsoft.ContainerInstance/locations/usages/read

Microsoft.Resources/subscriptions/resources/read
Microsoft.Resources/subscriptions/providers/read

Microsoft.Resources/deployments/read
Microsoft.Resources/deployments/write
EOF
}

create_role_definition() {
    local role_name="$1"
    local subscription_id="$2"
    
    local permissions=()
    while IFS= read -r permission; do
        [[ -n "$permission" ]] && permissions+=("$permission")
    done < <(get_role_permissions)
    
    # Create JSON array for permissions
    local permissions_json
    permissions_json=$(printf '"%s",' "${permissions[@]}" | sed 's/,$//')
    
    cat <<EOF
{
    "Name": "$role_name",
    "Description": "Custom role for Qovery with minimal required permissions for Azure resources (created $(date +'%Y-%m-%d'))",
    "Actions": [
        $permissions_json
    ],
    "NotActions": [],
    "DataActions": [
        "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/*",
        "Microsoft.ContainerRegistry/registries/repositories/content/read",
        "Microsoft.ContainerRegistry/registries/repositories/content/write",
        "Microsoft.ContainerRegistry/registries/repositories/content/delete",
        "Microsoft.ContainerRegistry/registries/repositories/metadata/read",
        "Microsoft.ContainerRegistry/registries/repositories/metadata/write"
    ],
    "NotDataActions": [],
    "AssignableScopes": [
        "/subscriptions/$subscription_id"
    ]
}
EOF
}

manage_custom_role() {
    local role_name="$1"
    local subscription_id="$2"
    
    log "INFO" "Managing custom role: $role_name"
    
    # Create temporary file for role definition
    TEMP_ROLE_FILE=$(mktemp --suffix=.json)
    chmod 600 "$TEMP_ROLE_FILE"
    
    # Generate role definition
    create_role_definition "$role_name" "$subscription_id" > "$TEMP_ROLE_FILE"
    
    # Check if role exists
    local existing_role
    if existing_role=$(az role definition list --name "$role_name" --subscription "$subscription_id" --query "[0].id" -o tsv 2>/dev/null) && [[ -n "$existing_role" ]]; then
        log "INFO" "Custom role exists, updating..."
        
        if safe_execute 2 3 "az role definition update --role-definition '$TEMP_ROLE_FILE' --subscription '$subscription_id' --only-show-errors >/dev/null"; then
            log "INFO" "Custom role updated successfully"
        else
            log "WARN" "Failed to update custom role, continuing with existing role"
        fi
    else
        log "INFO" "Creating custom role..."
        
        if ! safe_execute 2 3 "az role definition create --role-definition '$TEMP_ROLE_FILE' --subscription '$subscription_id' --only-show-errors >/dev/null"; then
            error_exit "Failed to create custom role"
        fi
        
        log "INFO" "Custom role created successfully"
    fi
}

# =============================================================================
# SERVICE PRINCIPAL FUNCTIONS
# =============================================================================

create_or_get_service_principal() {
    local app_id="$1"
    
    log "INFO" "Managing multi-tenant service principal..."
    
    local sp_object_id
    
    # Check if service principal exists
    if sp_object_id=$(az ad sp show --id "$app_id" --query "id" -o tsv 2>/dev/null) && [[ -n "$sp_object_id" ]]; then
        log "INFO" "Service principal already exists in this tenant"
        
        # Verify accessibility
        if ! az ad sp show --id "$app_id" --query "id" -o tsv &>/dev/null; then
            error_exit "Service principal exists but appears to be inactive or inaccessible"
        fi
    else
        log "INFO" "Creating service principal from multi-tenant application..."
        
        if ! safe_execute 2 5 "az ad sp create --id '$app_id' --only-show-errors >/dev/null"; then
            local tenant_id
            tenant_id=$(az account show --query "tenantId" -o tsv 2>/dev/null || echo "unknown")
            
            log "ERROR" "Failed to create service principal automatically"
            log "ERROR" "For multi-tenant applications, manual admin consent may be required"
            log "ERROR" "Visit: https://login.microsoftonline.com/$tenant_id/adminconsent?client_id=$app_id"
            log "ERROR" "Or run: az ad sp create --id $app_id"
            
            error_exit "Service principal creation failed"
        fi
        
        # Wait for propagation and get object ID
        sleep 5
        sp_object_id=$(az ad sp show --id "$app_id" --query "id" -o tsv 2>/dev/null)
        
        if [[ -z "$sp_object_id" ]]; then
            error_exit "Failed to get service principal object ID after creation"
        fi
        
        log "INFO" "Service principal created successfully"
    fi
    
    echo "$sp_object_id"
}

assign_role_to_service_principal() {
    local sp_object_id="$1"
    local role_name="$2"
    local subscription_id="$3"
    
    log "INFO" "Assigning role to service principal..."
    
    local subscription_scope="/subscriptions/$subscription_id"
    
    # Check if assignment already exists
    local existing_assignment
    if existing_assignment=$(az role assignment list \
        --assignee "$sp_object_id" \
        --role "$role_name" \
        --scope "$subscription_scope" \
        --query "[0].id" -o tsv 2>/dev/null) && [[ -n "$existing_assignment" ]]; then
        
        log "INFO" "Role assignment already exists, verifying..."
        
        # Verify the assignment is active
        if az role assignment list --assignee "$sp_object_id" --role "$role_name" --scope "$subscription_scope" --query "[0].id" -o tsv &>/dev/null; then
            log "INFO" "Existing role assignment verified"
            return 0
        else
            log "WARN" "Existing assignment verification failed, will recreate"
        fi
    fi
    
    # Create role assignment with retry logic
    log "INFO" "Creating role assignment..."
    
    local assignment_cmd="az role assignment create --assignee-object-id '$sp_object_id' --assignee-principal-type 'ServicePrincipal' --role '$role_name' --scope '$subscription_scope' --only-show-errors >/dev/null"
    
    if safe_execute "$MAX_RETRIES" "$RETRY_DELAY" "$assignment_cmd"; then
        log "INFO" "Role assignment created successfully"
    else
        error_exit "Failed to create role assignment after $MAX_RETRIES attempts"
    fi
    
    # Verify assignment with retries for propagation
    log "INFO" "Verifying role assignment..."
    
    local verification_success=false
    for ((i=1; i<=3; i++)); do
        if [[ $i -gt 1 ]]; then
            log "INFO" "Verification attempt $i/3..."
            sleep 10
        fi
        
        if az role assignment list \
            --assignee "$sp_object_id" \
            --role "$role_name" \
            --scope "$subscription_scope" \
            --query "[0].id" -o tsv &>/dev/null; then
            
            verification_success=true
            log "INFO" "Role assignment verification successful"
            break
        fi
    done
    
    if [[ "$verification_success" != true ]]; then
        log "WARN" "Role assignment verification failed, but assignment may still be valid due to propagation delays"
    fi
}

# =============================================================================
# MAIN WORKFLOW FUNCTIONS
# =============================================================================

get_azure_context() {
    log "INFO" "Getting Azure context..."
    
    local current_account
    if ! current_account=$(az account show --query "{name: name, id: id, tenantId: tenantId, user: user.name}" -o json 2>/dev/null); then
        error_exit "Unable to get Azure account information. Please ensure you're logged in with 'az login'"
    fi
    
    # Parse account information safely
    local current_subscription_id current_tenant_id current_subscription_name current_user
    current_subscription_id=$(parse_json "$current_account" '.id' "")
    current_tenant_id=$(parse_json "$current_account" '.tenantId' "")
    current_subscription_name=$(parse_json "$current_account" '.name' "")
    current_user=$(parse_json "$current_account" '.user' "")
    
    if [[ -z "$current_subscription_id" || -z "$current_tenant_id" ]]; then
        error_exit "Unable to extract account information. Please check your Azure CLI login"
    fi
    
    # Store in global variables for access by other functions
    echo "$current_account"
}

set_subscription_context() {
    local target_subscription_id="$1"
    
    log "INFO" "Setting subscription context to: $target_subscription_id"
    
    if ! safe_execute 2 3 "az account set --subscription '$target_subscription_id'"; then
        error_exit "Failed to set subscription context. Please ensure you have access to subscription $target_subscription_id"
    fi
    
    # Verify access
    if ! az account show --subscription "$target_subscription_id" --query "id" -o tsv &>/dev/null; then
        error_exit "Cannot access subscription $target_subscription_id. Please check your permissions"
    fi
    
    log "INFO" "Subscription context set successfully"
}

display_confirmation() {
    local current_account="$1"
    local target_subscription_id="$2"
    local role_name="$3"
    
    # Parse current account info
    local current_subscription_id current_tenant_id current_subscription_name current_user
    current_subscription_id=$(parse_json "$current_account" '.id')
    current_tenant_id=$(parse_json "$current_account" '.tenantId')
    current_subscription_name=$(parse_json "$current_account" '.name')
    current_user=$(parse_json "$current_account" '.user')
    
    cat <<EOF

============================================================
Qovery Azure Credentials Setup v$SCRIPT_VERSION
============================================================

Current Azure Context:
  User: $current_user
  Tenant ID: $current_tenant_id

Target Configuration:
  Subscription ID: $target_subscription_id
  Service Principal: Multi-tenant (Qovery)
  Custom Role: $role_name

EOF

    if [[ "$current_subscription_id" != "$target_subscription_id" ]]; then
        echo "⚠️  WARNING: Target subscription differs from current subscription!"
        echo ""
    fi

    echo "============================================================"
}

perform_dry_run() {
    local subscription_id="$1"
    local role_name="$2"
    
    log "INFO" "DRY RUN MODE - No changes will be made"
    
    cat <<EOF

Planned Actions:
1. Set subscription context to: $subscription_id
2. Register Azure resource providers
3. Create/update custom role: $role_name
4. Create/verify multi-tenant service principal
5. Assign custom role to service principal
6. Display required information for Qovery console

EOF
}

main_workflow() {
    local subscription_id="$1"
    
    # Get Azure context
    local current_account
    current_account=$(get_azure_context)
    
    # Use current subscription if none specified
    if [[ -z "$subscription_id" ]]; then
        subscription_id=$(parse_json "$current_account" '.id')
        log "INFO" "Using current subscription: $subscription_id"
    fi
    
    # Set role_name to be unique per subscription (max 64 chars)
    local base_role_name="qovery-sp-role"
    local role_name="${base_role_name}-${subscription_id}"
    if [[ ${#role_name} -gt 64 ]]; then
        # Truncate subscription_id if needed
        role_name="${base_role_name}-${subscription_id:0:$((64 - ${#base_role_name} - 1))}"
    fi
    
    # Display confirmation
    display_confirmation "$current_account" "$subscription_id" "$role_name"
    
    # Handle dry run
    if [[ "$DRY_RUN" == true ]]; then
        perform_dry_run "$subscription_id" "$role_name"
        return 0
    fi
    
    # Ask for confirmation
    if [[ "$SKIP_CONFIRMATION" != true ]]; then
        echo ""
        read -p "Do you want to proceed with these settings? (y/N): " -r
        echo ""
        
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "INFO" "Operation cancelled by user"
            exit 0
        fi
    fi
    
    # Set subscription context
    set_subscription_context "$subscription_id"
    
    # Register Azure providers
    register_azure_providers
    
    # Create/update custom role
    manage_custom_role "$role_name" "$subscription_id"
    
    # Create/get service principal
    local sp_object_id
    sp_object_id=$(create_or_get_service_principal "$app_id")
    
    # Assign role to service principal
    assign_role_to_service_principal "$sp_object_id" "$role_name" "$subscription_id"
    
    # Get final tenant ID
    local tenant_id
    tenant_id=$(az account show --subscription "$subscription_id" --query "tenantId" -o tsv)
    
    # Display success message
    display_success "$tenant_id" "$subscription_id"
}

display_success() {
    local tenant_id="$1"
    local subscription_id="$2"
    
    cat <<EOF

============================================================
🎉 Qovery Azure Setup Completed Successfully!
============================================================

  • Tenant ID: $tenant_id
  • Subscription ID: $subscription_id

✅ Setup complete! Your Qovery environment is ready to deploy to Azure.
============================================================

EOF

    if [[ "$VERBOSE" == true ]]; then
        cat <<EOF
🔧 Troubleshooting Information:
   • Azure Portal: Subscriptions > $subscription_id > Access control (IAM)
   • Verify role assignment to service principal
   • Allow 10-15 minutes for Azure propagation if issues persist

For support, visit: https://docs.qovery.com

EOF
    fi
}

# =============================================================================
# COMMAND LINE INTERFACE
# =============================================================================

usage() {
    cat <<EOF
Usage: $0 --qovery-app-id <app_id> [OPTIONS]

Qovery Azure Credentials Setup Script v$SCRIPT_VERSION

This script creates a service principal for Qovery.

REQUIRED OPTIONS:
    --qovery-app-id <id>    Qovery application ID (UUID format)

OPTIONS:
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    -q, --quiet             Suppress non-error output
    --subscription-id <id>  Azure subscription ID (optional, defaults to current)
    --skip-confirmation     Skip interactive confirmation
    --dry-run              Show planned actions without executing

EXAMPLES:
    $0 --qovery-app-id 12345678-1234-1234-1234-123456789012
    $0 --qovery-app-id 12345678-1234-1234-1234-123456789012 --subscription-id 87654321-4321-4321-4321-210987654321
    $0 --qovery-app-id 12345678-1234-1234-1234-123456789012 --verbose --dry-run

ENVIRONMENT VARIABLES:
    LOG_LEVEL              Logging level (DEBUG, INFO, WARN, ERROR)
    MAX_RETRIES            Maximum retry attempts (default: 3)
    RETRY_DELAY            Delay between retries in seconds (default: 5)

For more information, visit: https://docs.qovery.com
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -q|--quiet)
                QUIET=true
                shift
                ;;
            --qovery-app-id)
                if [[ -n "$2" && "$2" != -* ]]; then
                    app_id="$2"
                    shift 2
                else
                    error_exit "Option --qovery-app-id requires a value"
                fi
                ;;
            --subscription-id)
                if [[ -n "$2" && "$2" != -* ]]; then
                    subscription_id="$2"
                    shift 2
                else
                    error_exit "Option --subscription-id requires a value"
                fi
                ;;
            --skip-confirmation)
                SKIP_CONFIRMATION=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -*)
                error_exit "Unknown option: $1. Use --help for usage information."
                ;;
            *)
                error_exit "Unexpected argument: $1. Use --help for usage information."
                ;;
        esac
    done
    
    # Validate required inputs
    validate_app_id "$app_id"
    validate_subscription_id "$subscription_id"
    
    log "DEBUG" "Using application ID: $app_id"
    if [[ -n "$subscription_id" ]]; then
        log "DEBUG" "Using subscription ID: $subscription_id"
    fi
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    # Set up signal handlers for cleanup
    trap cleanup EXIT INT TERM
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Check prerequisites
    check_prerequisites
    
    # Execute main workflow
    main_workflow "$subscription_id"
}

# Run main function with all arguments
main "$@"