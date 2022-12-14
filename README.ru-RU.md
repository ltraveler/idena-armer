<h1 align="center">
  <img alt="IDENA ARMer Bash Скрипт - быстрый способ установить ноду Идена (idena-go) на телефон или другой устройство Android" src="https://raw.githubusercontent.com/ltraveler/ltraveler/main/images/IDENA_ARMer_400_ru.png"/><br/>
  🦾 IDENA ARMer — Установка, запуск, настройка и обновление ноды ИДЕНА, <span style="font-size: 95%; color: gray;">на мобильном устройстве или телефоне Android с архитектурой ARM64</span>
</h1>

<p align="justify"><b>Установщик Идена</b> для платформы ARM64 в виде bash скрипта. Позволяет устанавить ноду <b>Idena-Go</b> на ваше мобильное устройство или телефон в виде простого и понятного мастера с дружественным интерфейсом.</p>

<p align="center"><a href="https://github.com/ltraveler/idena-runner/releases/latest" target="_blank"><img src="https://img.shields.io/github/v/release/ltraveler/idena-armer?style=for-the-badge&logo=none" alt="idena armer latest version" /></a>&nbsp;<a href="https://wiki.ubuntu.com/FocalFossa/ReleaseNotes" target="_blank"><img src="https://img.shields.io/badge/Kali-20.04(LTS)+-00ADD8?style=for-the-badge&logo=none" alt="Kali minimum version" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/CHANGELOG.md" target="_blank"><img src="https://img.shields.io/badge/Build-Stable-success?style=for-the-badge&logo=none" alt="idena-go latest release" /></a>&nbsp;<a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank"><img src="https://img.shields.io/badge/лицензия-GPL3.0-red?style=for-the-badge&logo=none" alt="license" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-armer/blob/master/README.md" target="_blank"><img src="https://img.shields.io/badge/readme-ENGLISH-orange?style=for-the-badge&logo=none" alt="Скрипт Idena ARMer" /></a></p>

## 📈 Требования к устройству

**Скрипт тестировался на устройстве Samsung Galaxy S6:**
* _Exynos 7420_
* _8 ядер_
* _2.6 ГБ ОЗУ._
* _Kali Linux_

_Во время валидации, часть ключевых слов оказалось не до конца прогруженными. Однозначно ответить, связано ли это с характеристиками устройства, не представляется возможным так-как, уровень нагрузки устройства во время валидации оставался в рамках допустимых значений_

## 🚀&nbsp; Краткое содержание
1. Установка репозитория приложений **F-Droid**
2. Устанавка приложений **Termux** и **Termux:boot** из репозитория **F-Droid**.
3. Запуск приложений **Termux** и **Termux:boot** в первый раз, для базовой инициализации.
4. `termux-setup-storage` - предоставление доступа для приложения **Termux** к хранилищу вашего устройства.
5. Добавление **Termux** и **Termux:boot** в список исключений монитора энергопотребления.
6. `pkg upgrade -y` - обновление пакетов терминала termux до последней версии.
7. Скачивание и запуск скрипта `termux_init.sh` для подготовки вашего терминала Termux к хосту Kali Linux:
```
curl -O https://raw.githubusercontent.com/ltraveler/idena-armer/master/termux_init.sh
chmod +x ./termux_init.sh && ./termux_init.sh
```
8. `./start-kali.sh` - запуск Kali Linux.
9. `apt update && apt upgrade -y` - обновление пакетов Kali Linux до последней версии.
10. `apt install git -y` - установка пакета git.
11. `git clone https://github.com/ltraveler/idena-armer.git` - клонирование репозитория IDENA ARMer
12. `cd idena-armer && chmod +x ARMer_init.sh &&./ARMer_init.sh` - запуск скрипта конфигурирования клиента ноды idena-go и следование дальнейшим инструкциям мастера.
13. Перезагрузка телефона.


## 📗&nbsp; Детальная инструкция доступна здесь:
https://teletype.in/@idenanetwork/idena-armer

## 👀&nbsp; [IDENA Coacher](https://github.com/ltraveler/idena-coacher) — Менеджер управления нодой
1. **IDENA ARMer** автоматически установит **IDENA Coacher** специальную утилиту для управления вашей нодой.
2. Менеджер будет установлен в домашнюю директорию пользователя который был указан во время установки скрипта.
3. Запуск скрипта.
```
idena_coacher.sh
```
4. После запуска перед вами должно появится главное окно програмы, с основной информацией о вашей ноде.

<p align="center"><br>
  <img alt="Idena Coacher - менеджер управления нодой" Title="IDENA Coacher - Интерфейс пользователя" src="https://raw.githubusercontent.com/ltraveler/ltraveler/main/images/IDENA_Coacher_Monitor_Tool_UI.jpg">
</p>
