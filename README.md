# HW-DevOps

Bash-скрипт для автоматической установки инструментов разработки.

## install_dev-tools.sh

Устанавливает: **Docker**, **Docker Compose**, **Python 3.9+**, **Django**

### Использование

```bash
chmod u+x install_dev-tools.sh
./install_dev-tools.sh
newgrp docker  # После установки
```

### Особенности

- Проверяет установленные инструменты (избегает дублирования)
- Добавляет пользователя в группу docker
- Поддерживает Ubuntu/Debian

**Требования:** Ubuntu 20.04+ или Debian 11+, sudo, интернет
