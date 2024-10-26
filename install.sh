#!/bin/bash

echo "Установка необходимых зависимостей... ( xorg-server, bspwm, alacritty, sxhkd, vim, ly, picom, zsh, feh)"
sudo pacman -S --noconfirm xorg-server xorg-xrandr bspwm alacritty sxhkd vim ly picom zsh feh

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

systemctl enable ly.service

echo "Создание директорий для конфигурации... ( ~/.config/bspwm )"
mkdir -p ~/.config/bspwm
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/picom
mkdir -p ~/wallpapers

echo "Копирование конфигурационных файлов..."
mv ~/Downloads/bspwm-example/bspwmrc ~/.config/bspwm/
mv ~/Downloads/bspwm-example/sxhkdrc ~/.config/bspwm/
mv ~/Downloads/bspwm-example/alacritty.toml ~/.config/alacritty/
mv ~/Downloads/bspwm-example/picom.conf ~/.config/picom/
mv ~/Downloads/bspwm-example/.xsession ~/
mv ~/Downloads/bspwm-example/x.jpg ~/wallpapers

read -p "Хотите установить разрешение экрана 1920x1080 с частотой 144 Гц на HDMI-0? (Y/n): " choice
choice=${choice:-Y}

if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
    echo "xrandr --output HDMI-0 --mode 1920x1080 --rate 144" >> ~/.xsession
elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
    echo "Установка разрешения экрана пропущена."
else
    echo "Неверный ввод. Установка разрешения экрана отклонена."
fi

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.xsession

read -p "Хотите установить firefox-bin? (Y/n): " choice
choice=${choice:-Y}

if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
echo "Установка необходимых зависимостей... (curl, tar, alsa-lib)"
sudo pacman -S --noconfirm curl tar alsa-lib

cd ~/Downloads || { echo "Не удалось перейти в папку загрузок. ~/Downloads"; exit 1; }

echo "Загрузка Firefox..."
curl -L -o firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US&_gl=1*1irdmrv*_ga*Nzg1NTczMTE0LjE3Mjk5Mzc4NDA.*_ga_MQ7767QQQW*MTcyOTkzNzg0MC4xLjEuMTcyOTkzODA0MS4wLjAuMA.."

echo "Извлечение Firefox..."
tar xjf firefox.tar.bz2

echo "Перемещение Firefox в /opt..."
sudo mv firefox /opt

echo "Создание символической ссылки..."
sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox

echo "Firefox установлен успешно! Вы можете запустить его, введя 'firefox' в терминале." 
elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
    echo "Установка firefox-bin пропущена."
else
    echo "Неверный ввод. Установка отклонена."
fi

echo "Пожалуйста, перезапустите сессию или запустите 'bspwm' для начала работы."
