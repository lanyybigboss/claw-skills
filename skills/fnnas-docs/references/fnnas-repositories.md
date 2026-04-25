# FnNAS (飞牛NAS) GitHub Repositories

## Official Repositories

### 1. ophub/fnnas (Main Repository)
**URL**: https://github.com/ophub/fnnas
**Description**: Supports running FnNAS on Amlogic, Allwinner, and Rockchip devices.
**Supported Devices**: 
- Amlogic: a311d, s922x, s905x3, s905x2, s912, s905d, s905x, s905w, s905, s905l
- Allwinner: h6
- Rockchip: rk3588, rk3568, rk3399, rk3328

### 2. FNOSP/fnnas-api (API Repository)
**URL**: https://github.com/FNOSP/fnnas-api
**Description**: 飞牛NAS网页API (FnNAS Web API)
**Purpose**: Web API documentation and implementation

### 3. ckcoding/fnnas-docs (Documentation Repository)
**URL**: https://github.com/ckcoding/fnnas-docs
**Description**: 飞牛应用开放平台开发文档 (FnNAS Application Open Platform Development Documentation)
**Purpose**: Developer documentation, synced from official documentation site

### 4. ophub/kernel (Kernel Repository)
**URL**: https://github.com/ophub/kernel
**Description**: Supports kernel for Armbian, OpenWrt, and FnNAS.
**Purpose**: Kernel support for FnNAS

### 5. ophub/u-boot (U-boot Repository)
**URL**: https://github.com/ophub/u-boot
**Description**: Supports u-boot for Armbian, OpenWrt, and FnNAS.
**Purpose**: Bootloader support for FnNAS

### 6. ophub/firmware (Firmware Repository)
**URL**: https://github.com/ophub/firmware
**Description**: Supports firmware for Armbian, OpenWrt, and FnNAS.
**Purpose**: Firmware support for FnNAS

## Related Repositories

### Community Projects
- QYG2297248353/AMMDS-Offline-FnNas - 飞牛应用商店 - 离线版
- QYG2297248353/MetaTube-Offline-FnNas - 飞牛应用商店 - 离线版
- QYG2297248353/DPanel-Offline-FnNas - 飞牛应用商店 - 离线版
- lilonghe/memos-fnnas - build for fnnas
- hillghost86/FNnas-Docker-Proxy - Docker registry proxy for FnNAS

### App Store Repositories
- fnnas/appstore.grafana.alloy
- fnnas/appstore.grafana.loki
- fnnas/appstore.prometheus.prometheus
- fnnas/appstore.prometheus.node_exporter
- fnnas/appstore.driver.network.rtw89

## Official Documentation Site

**Developer Documentation**: https://developer.fnnas.com/docs/guide

## GitHub Topics
FnNAS repositories typically have these topics:
- nas
- storage
- arm
- amlogic
- rockchip
- allwinner
- docker
- armbian

## FnNAS Platform Architecture

### Core Components
1. **ophub/fnnas** - Main NAS system for ARM devices
2. **ophub/kernel** - Kernel support
3. **ophub/u-boot** - Bootloader support
4. **ophub/firmware** - Firmware support

### API Layer
1. **FNOSP/fnnas-api** - Web API
2. **ckcoding/fnnas-docs** - Documentation

### App Ecosystem
1. **App Store** - Various application containers
2. **Docker Integration** - Docker registry proxy
3. **Community Apps** - Third-party applications

## Device Support Matrix

### Amlogic Support
- a311d
- s922x
- s905x3
- s905x2
- s912
- s905d
- s905x
- s905w
- s905
- s905l

### Rockchip Support
- rk3588
- rk3568
- rk3399
- rk3328

### Allwinner Support
- h6

## Documentation Sources

### Primary Sources
- GitHub README files
- GitHub Wiki (if available)
- Official documentation site
- Issues and discussions

### Secondary Sources
- Community forums
- Chinese tech blogs
- Device-specific documentation

## Usage Patterns

### Installation
```bash
# See ophub/fnnas repository for installation guides
```

### API Usage
```bash
# See FNOSP/fnnas-api for API documentation
```

### Development
```bash
# See ckcoding/fnnas-docs for developer guides
```

### Kernel Development
```bash
# See ophub/kernel for kernel customization
```