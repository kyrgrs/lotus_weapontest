# Lotus_Weapontest

**Author:** Axton  
**Script Name:** Lotus_Weapontest

## Description

This script allows players to take an exam to obtain a weapon license. If they pass, the "weaponlicense" item is added to their inventory. The script is based on the vms_vehicleshopv2 script and has been adapted for a weapon license system.

## How Does It Work?

- Players can take the weapon license exam at a designated location.
- If the player successfully completes the exam, the "weaponlicense" item is added to their inventory.
- The script is compatible with both ESX and QB-Core frameworks.
- License checks are performed directly via inventory, not metadata.

## Installation

1. Place the script in the `resources` folder.
2. Make sure the following item definition is added to your `ox_inventory/data/items.lua` file:
    ```lua
    ["weaponlicense"] = {
        label = "Weapon License",
        weight = 0,
        stack = false,
        close = true,
        description = "Weapon License",
        client = {
            image = "weapon_license.png",
        }
    },
    ```
3. Restart your server.

## Notes

- The script was developed using the [vms_vehicleshopv2](https://www.vames-store.com/category/scripts) script.

---
