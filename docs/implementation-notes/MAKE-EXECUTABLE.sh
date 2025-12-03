#!/bin/bash
# Make all Bosque-related scripts executable

chmod +x scripts/install_bosque.sh
chmod +x scripts/verify_bosque.sh
chmod +x TEST-BOSQUE.sh
chmod +x agent-os/specs/2025-12-03-language-toolchain-setup/UPDATE-TASKS-BOSQUE.sh

echo "All Bosque scripts are now executable:"
echo "  ✓ scripts/install_bosque.sh"
echo "  ✓ scripts/verify_bosque.sh"
echo "  ✓ TEST-BOSQUE.sh"
echo "  ✓ agent-os/specs/.../UPDATE-TASKS-BOSQUE.sh"
echo ""
echo "You can now run:"
echo "  ./TEST-BOSQUE.sh          - Full installation and verification"
echo "  ./scripts/install_bosque.sh  - Just install Bosque"
echo "  ./scripts/verify_bosque.sh   - Just verify installation"
