---
title: VM Windows 11 dans Hyper-V
date: 2023-12-28
category: Divers
layout: post
description: Déploiement d'une machine virtuelle Windows 11 dans Hyper-V
---

> :point_right: J'ai testé dans Hyper-V 2019 (pas 2022), je n'y arrive pas via la GUI
{: .block-tip }

Ce script fonctionne:
```powershell
$VMName = "win11" #Read-Host -Prompt "Please provide the Virtual Machine Name"
$SwitchName = "Interne" #Read-Host -Prompt "Please provide the name of the Virtual Switch to be used"
$ISOFile = "C:\Users\Administrateur\Desktop\fr-fr_windows_11_business_editions_updated_dec_2021_x64_dvd_1e4974c3.iso" #Read-Host -Prompt "Please provide the full path for the Windows Server 2022 install media (ISO file)"
$VMPath = "C:\Hyper-V" # Read-Host -Prompt "Please provide the path to store the VM"
New-VM -Name $VMName -Generation 2 -MemoryStartupBytes 4096MB -SwitchName $SwitchName -Path $VMPath -NewVHDPath $VMPath\$VMName\virtualdisk\VHD.vhdx -NewVHDSizeBytes 127000MB
Set-VM -Name $VMName -ProcessorCount 4 -AutomaticCheckpointsEnabled $false
Add-VMDvdDrive -VMName $VMName -Path $ISOFile
$DVDDrive = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -BootOrder $DVDDrive -VMName $VMName
Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
Enable-VMTPM -VMName $VMName
```
