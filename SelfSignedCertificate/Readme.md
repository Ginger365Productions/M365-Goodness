📦 MSIX Code Signing Certificate Script

This script automates the creation, export, and management of a self‑signed code‑signing certificate used for signing MSIX application packages. It ensures that you have both the private key (.pfx) and public key (.cer) available, and that the certificate is trusted on the local machine for package validation.



🔍 Overview

MSIX packages must be signed with a valid code‑signing certificate. In development or internal testing scenarios, a self‑signed certificate is sufficient. This script:



Creates a self‑signed certificate suitable for MSIX signing



Stores it in the correct certificate store



Exports the private key (.pfx) with a password



Imports the certificate into the TrustedPeople store



Exports the public key (.cer) for distribution



Provides a safe way to re‑load the certificate if the PowerShell session is closed



🛠 What the Script Does (Step‑by‑Step)

1\. Create a Self‑Signed Certificate

The script defines certificate parameters including:



Key usage: DigitalSignature



Store location: Cert:\\CurrentUser\\My



Subject: CN=Ginger365Productions, O=Ginger365Guy, C=UK



Friendly name: Code Signing Cert



Extensions: Required for code‑signing scenarios



It then generates the certificate using:



powershell

$cert = New-SelfSignedCertificate @certParams

2\. Display Certificate Details

Switches to the certificate store and lists certificates so you can verify:



Subject



FriendlyName



Thumbprint



Useful for confirming creation and identifying the certificate later.



3\. Export the Private Key (.pfx)

The script exports the certificate (including private key) to:



Code

C:\\Users\\malco\\Documents\\MSIXCodeCert.pfx

A secure password is applied using ConvertTo-SecureString.



This .pfx file is required for signing MSIX packages.



4\. Import Certificate into TrustedPeople

MSIX installers must trust the signing certificate.

The script imports the .pfx into:



Code

Cert:\\CurrentUser\\TrustedPeople

This ensures Windows recognises the certificate as trusted when installing your MSIX package.



5\. Export the Public Key (.cer)

The script exports a .cer file containing the public key only:



Code

C:\\Users\\malco\\Documents\\CodeCert.cer

This file is typically distributed to users or deployment systems so they can trust your signed MSIX packages.



6\. Reload Certificate After Terminal Restart

If PowerShell is closed, the certificate object $cert is lost.

The script retrieves it again by matching the friendly name:



powershell

$cert = Get-ChildItem Cert:\\CurrentUser\\My | Where-Object { $\_.FriendlyName -eq 'Code Signing Cert' }

This ensures the certificate can be reused for signing operations without recreating it.



📁 Output Files

File	Purpose

MSIXCodeCert.pfx	Private key used for signing MSIX packages

CodeCert.cer		Public key used for trusting the signed packages





