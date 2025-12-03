#!/bin/bash

# Documentation Verification Script
# Part of Task Group 8.3: Verify all documentation is accurate and complete
# Checks all documentation files for completeness, accuracy, and broken links

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source common utilities
source "${SCRIPT_DIR}/common.sh"

# Verification results
DOC_ISSUES=()
CHECKED_DOCS=0

# Check if a file exists
check_file_exists() {
    local file="$1"
    local description="$2"

    if [[ ! -f "$file" ]]; then
        DOC_ISSUES+=("MISSING: $description at $file")
        return 1
    fi

    CHECKED_DOCS=$((CHECKED_DOCS + 1))
    return 0
}

# Check if documentation contains required sections
check_required_sections() {
    local file="$1"
    local description="$2"
    shift 2
    local required_sections=("$@")

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    for section in "${required_sections[@]}"; do
        if ! grep -qi "$section" "$file"; then
            DOC_ISSUES+=("INCOMPLETE: $description missing section: $section")
        fi
    done

    return 0
}

# Check for broken local file references
check_local_references() {
    local file="$1"
    local description="$2"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Extract file paths from markdown links like [text](path)
    local references
    references=$(grep -oE '\[.*?\]\(([^http][^)]+)\)' "$file" | grep -oE '\([^)]+\)' | tr -d '()' || true)

    if [[ -n "$references" ]]; then
        while IFS= read -r ref; do
            # Skip empty lines and anchors
            [[ -z "$ref" ]] && continue
            [[ "$ref" == "#"* ]] && continue

            # Convert relative path to absolute
            local doc_dir
            doc_dir=$(dirname "$file")
            local abs_path="${doc_dir}/${ref}"

            if [[ ! -f "$abs_path" ]] && [[ ! -d "$abs_path" ]]; then
                DOC_ISSUES+=("BROKEN_LINK: $description has broken link to $ref")
            fi
        done <<< "$references"
    fi

    return 0
}

# Main verification
main() {
    log_info "=================================================="
    log_info "Documentation Verification"
    log_info "=================================================="
    echo ""

    # Check main project documentation
    log_info "Checking main project documentation..."

    check_file_exists "${PROJECT_ROOT}/README.md" "Main README"
    check_required_sections "${PROJECT_ROOT}/README.md" "Main README" \
        "Quick Start" \
        "Prerequisites" \
        "Installation" \
        "Troubleshooting"

    check_local_references "${PROJECT_ROOT}/README.md" "Main README"

    # Check per-language documentation
    log_info "Checking per-language documentation..."

    local languages=("rust" "gleam" "roc" "carbon" "bosque")
    for lang in "${languages[@]}"; do
        local doc_file="${PROJECT_ROOT}/docs/languages/${lang}.md"
        check_file_exists "$doc_file" "${lang} documentation"

        check_required_sections "$doc_file" "${lang} documentation" \
            "Installation" \
            "Quick Start" \
            "Troubleshooting" \
            "Resources"

        check_local_references "$doc_file" "${lang} documentation"
    done

    # Check VS Code setup guide
    log_info "Checking VS Code setup guide..."

    check_file_exists "${PROJECT_ROOT}/docs/vscode-setup.md" "VS Code setup guide"
    check_required_sections "${PROJECT_ROOT}/docs/vscode-setup.md" "VS Code setup guide" \
        "rust-analyzer" \
        "Gleam" \
        "Roc" \
        "Carbon" \
        "Bosque"

    # Check troubleshooting documentation (optional, created in 8.5)
    if [[ -f "${PROJECT_ROOT}/docs/troubleshooting.md" ]]; then
        log_info "Checking troubleshooting documentation..."
        check_local_references "${PROJECT_ROOT}/docs/troubleshooting.md" "Troubleshooting documentation"
    fi

    # Check for typos and common issues in all docs
    log_info "Checking for common documentation issues..."

    # Check for TODO or FIXME markers
    local todo_count
    todo_count=$(grep -r "TODO\|FIXME\|XXX" "${PROJECT_ROOT}/docs/" "${PROJECT_ROOT}/README.md" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$todo_count" -gt 0 ]]; then
        DOC_ISSUES+=("WARNING: Found $todo_count TODO/FIXME markers in documentation")
    fi

    # Check for placeholder text
    local placeholder_count
    placeholder_count=$(grep -ri "placeholder\|coming soon\|to be added" "${PROJECT_ROOT}/docs/" "${PROJECT_ROOT}/README.md" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$placeholder_count" -gt 0 ]]; then
        DOC_ISSUES+=("WARNING: Found $placeholder_count placeholder text instances")
    fi

    # Generate report
    echo ""
    log_info "=================================================="
    log_info "DOCUMENTATION VERIFICATION REPORT"
    log_info "=================================================="
    echo ""

    log_info "Documents checked: $CHECKED_DOCS"
    log_info "Issues found: ${#DOC_ISSUES[@]}"
    echo ""

    if [[ ${#DOC_ISSUES[@]} -eq 0 ]]; then
        log_success "All documentation verified successfully!"
        log_info ""
        log_info "Documentation Summary:"
        log_info "  - Main README: Complete"
        log_info "  - Language guides (5): Complete"
        log_info "  - VS Code setup: Complete"
        log_info "  - Local links: All valid"
        return 0
    else
        log_warn "Found ${#DOC_ISSUES[@]} documentation issues:"
        echo ""
        for issue in "${DOC_ISSUES[@]}"; do
            local issue_type="${issue%%:*}"
            local issue_msg="${issue#*:}"

            case "$issue_type" in
                MISSING)
                    log_error "  $issue_msg"
                    ;;
                INCOMPLETE)
                    log_warn "  $issue_msg"
                    ;;
                BROKEN_LINK)
                    log_error "  $issue_msg"
                    ;;
                WARNING)
                    log_warn "  $issue_msg"
                    ;;
                *)
                    log_info "  $issue"
                    ;;
            esac
        done
        echo ""

        # Count critical vs warning issues
        local critical=0
        local warnings=0
        for issue in "${DOC_ISSUES[@]}"; do
            if [[ "$issue" == "MISSING:"* ]] || [[ "$issue" == "BROKEN_LINK:"* ]]; then
                critical=$((critical + 1))
            else
                warnings=$((warnings + 1))
            fi
        done

        if [[ $critical -gt 0 ]]; then
            log_error "Found $critical critical issues that must be fixed"
            return 1
        else
            log_warn "Found $warnings warnings (non-critical)"
            log_info "Documentation is acceptable but could be improved"
            return 0
        fi
    fi
}

# Run main function
main "$@"
