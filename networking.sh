#!/in/bash
# Network Configurator Script

configureAP() {}

echo "		+--------------------------------------+"
echo "		| Network Configurator Script 0.1      |"
echo "		+--------------------------------------|"

echo "Comenzando busqueda de redes WiFi conocidas"

conectado=false

redes=("Wiffindor" "Arkham" "Android")

for redes in "${redes[@]}"
do
	if iwlist wlan0 scan | grep $redes > /dev/null
	then
		echo "La red WiFi más cercana es: " $redes
		echo "Intentando conectar desde el fichero wpa_supplicant"
		wpa_suplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null 2>&1
		echo "Intentando obtener IP mediante DHCP"
		if dhclient -1 wlan0
		then
			echo "Conectado a la red" $redes
			conectado=true
			break
		else
			echo "El servicio DHCP no ha respondido con ninguna concesion IP válida"
			wpa_cli terminate
			break
		fi
	else
		echo "No se ha encontrado ningua de las siguientes redes WiFi: " $redes
	fi
done

