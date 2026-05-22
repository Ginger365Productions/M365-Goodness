M365 PowerShell Module Updater / Installer / Repair Engine

A standalone PowerShell utility that automatically installs, updates, and repairs the full suite of Microsoft 365 administration modules.

This script is designed to ensure your workstation always has a clean, healthy, and up‑to‑date Microsoft 365 PowerShell environment — without manual intervention.



After 30 years in the industry, I’ve learned that the best way we move forward is by sharing what we build. This script is part of that effort: helping others work smarter, not harder.



Overview

PSModuleUpdater.ps1 is a self‑contained script that:



Installs missing Microsoft 365 PowerShell modules



Updates outdated modules



Repairs modules that fail to update



Produces a version report



Performs a post‑update health check



Provides clear, colour‑coded output for every action



It requires no external framework, no custom classes, and no dependencies beyond PowerShell itself.



Modules Managed

The script maintains a curated list of Microsoft 365 administration modules, including:



Microsoft Graph (v2)



Microsoft Graph Beta



Exchange Online Management



Microsoft Teams



AzureAD \& AzureADPreview



MSOnline



SharePoint Online (PnP + SPO)



Intune / Defender / Purview



PowerApps Administration modules



Each module has a defined minimum required version, ensuring consistency across environments.



How It Works

1\. Version Scan

The script checks each module and reports:



Installed version



Required version



Status (OK / Outdated / Missing)



2\. Install / Update / Repair

For each module:



Missing → Installed



Outdated → Updated



Update fails → Repaired (full uninstall + clean install)



This ensures modules are always left in a working state.



3\. Health Check

After all operations, the script verifies that each module is present and healthy.



4\. Clean Output

All output is:



Colour‑coded



Human‑readable



Logged to the console



Free of interpolation bugs or parser errors



Usage

Run the script in PowerShell 5.1 or PowerShell 7+:



powershell

.\\PSModuleUpdater.ps1

Administrator rights are recommended because module installation typically writes to system‑wide module paths.



File Structure

Code

/M365-Goodness

│

├── PSModuleUpdater.ps1

└── README.md

More scripts and tooling will be added over time.



Contributing

If you have ideas, improvements, or additional modules that should be included, feel free to open an issue or submit a pull request. Collaboration is always welcome.



About This Project

This repository is part of my ongoing effort to share the scripts, tools, and automation patterns I’ve built throughout my career. If it helps you save time, avoid frustration, or streamline your Microsoft 365 admin workflow — then it’s done its job.

