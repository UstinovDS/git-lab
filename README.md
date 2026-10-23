# Лабораторная 2: Docker Compose + KVM (уровень 8)

## Приложение
- `backend/` — Flask, эндпоинт `GET /api/hello`
- `frontend/` — nginx: статическая страница и прокси `/api/` на бэкенд
- `compose.yaml` — запуск обоих сервисов

## Схема «ноутбук → VM → контейнеры»
Браузер (Windows) → `localhost:8081` → проброс портов QEMU в WSL2 → порт 8080 в VM → контейнер frontend (nginx :80) → контейнер backend (Flask :5000)

## Адрес приложения
http://localhost:8081

## Создание VM
Команды в `vm/create-vm.sh`: QEMU с ключом `-enable-kvm`, образ Ubuntu 22.04 cloud, вход по SSH-ключу.
Проброс портов: 2222 → SSH в VM, 8081 → порт 8080 в VM.
KVM работает внутри WSL2 (Ubuntu 22.04). Проверка виртуализации и вывод команд — в `docs/evidence.txt`.

## Команды запуска
1. Создать и запустить VM: `bash vm/create-vm.sh`
2. Поставить Docker в VM: `ssh -i ~/.ssh/vm_key -p 2222 ubuntu@localhost 'curl -fsSL https://get.docker.com | sudo sh && sudo usermod -aG docker ubuntu'`
3. Скопировать файлы: `scp -i ~/.ssh/vm_key -P 2222 -r backend frontend compose.yaml ubuntu@localhost:~/app/`
4. Запустить приложение: `ssh -i ~/.ssh/vm_key -p 2222 ubuntu@localhost 'cd ~/app && docker compose up -d --build'`

## Проверка связи фронтенда с бэкендом
- Из консоли: `curl http://localhost:8081/api/hello` возвращает JSON с сообщением.
- В браузере страница `http://localhost:8081` показывает это сообщение (запрос идёт к `/api/hello` через nginx).

## Результаты
Скриншот страницы: ![страница](docs/screenshot.png)

Вывод проверок: `docs/evidence.txt`
