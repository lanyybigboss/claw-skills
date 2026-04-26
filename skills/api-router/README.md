# API Router Skill

智能路由API，词元耗尽时自动切换。

## Usage

### 初始化配置
```bash
api-router init
```

### 查看状态
```bash
api-router status
```

### 切换API
```bash
api-router switch-api kuaipao
```

### 添加API
```bash
api-router add-api api1 "https://api.example.com/v1" "sk-xxx" "gpt-3.5-turbo"
```

### 检查词元
```bash
api-router check-tokens
```

## 智能路由逻辑

### 路由策略
1. **成本优先** - 选择成本最低的API
2. **质量优先** - 选择质量最高的API
3. **词元监控** - 监控词元使用量
4. **自动切换** - 词元耗尽时自动切换

### 配置更新
```bash
update-openclaw-config update api1
```

## API配置模板

```json
{
    "apis": [
        {
            "name": "kuaipao",
            "url": "https://kuaipao.ai/v1",
            "token": "sk-TizHhGxXSTb4DYtkqRpuumYPdWvY2xI6Iu0wY9xkrXF2Stgy",
            "model": "gpt-3.5-turbo",
            "cost": 0.01,
            "priority": 1
        }
    ]
}
```

## OpenClaw配置

需要更新OpenClaw配置文件：
```bash
update-openclaw-config update kuaipao
```

## 使用方法

### 1. 创建配置模板
```bash
api-config template
```

### 2. 填入base url和密钥
编辑 `api-config.json`

### 3. 更新OpenClaw配置
```bash
update-openclaw-config update kuaipao
```

### 4. 测试智能路由
```bash
smart-router route chat
```