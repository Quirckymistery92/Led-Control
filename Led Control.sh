#!/bin/sh

#Variables

VERSION="1.1";
DATEC="10 Enero 2023";
NAME="Led Control for OpenWRT";
NAMEC="Alex Jaque";
VERSIONB="1c";

#Variables de archivos temp & dates.

SCRIPT_DIR="$(pwd)/"
FILE_TEMP=""$SCRIPT_DIR"control.states";

#funciones 

timer () {
case "$1" in
            '1')
                start=$(date +%s)
                sed -i "4s/0000000/$start/" $FILE_TEMP;;
            '0')
                end=$(date +%s)
                local TIEMPO_A="$(($end-$STATE_TIME))"
                TIEMPO_T="$(date -d@$TIEMPO_A -u +%H:%M:%S)"
                sed -i "4s/$STATE_TIME/0000000/" $FILE_TEMP;;
esac
}

cargar_datos () {
        STATE_LED="$(cat $FILE_TEMP | grep "STATE_LED" | awk '{print $2}')"
       STATE_COM="$(cat $FILE_TEMP | grep "STATE_COM" | awk '{print $2}')"
       STATE_TIME="$(cat $FILE_TEMP | grep "STATE_TIME" | awk '{print $2}')"
}

enviar_ifttt () {
     case "$STATE_COM" in
                        '1')
                            curl -X POST --silent -o /dev/null -H "Content-Type: application/json" -d '{"value1":"'"$1"'"}' https://maker.ifttt.com/trigger/OpenWRT/with/key/ce2jsdS9wJAzrmkndKgTaJPn_A9SxdF--qGq3O4SJfK;;
                        '0')
                            echo;;
                        '*')
                        echo "El archivo temporal esta dañado o modificado incorrectamente, por favor, eliminelo";;
esac
}

led_control () {
x=1
while [ $x -le $1 ]
do
  echo "255" > /sys/class/leds/green:lan/brightness && sleep 0.3 && echo "0" > /sys/class/leds/green:lan/brightness && sleep 0.3
  x=$(( $x + 1 ))
done

}
state_main () {
         case "$STATE_LED" in
                                '1')
                                    led_control 3
                                    timer 1
                                    enviar_ifttt "Se inició el sistema. Hora de inicio: "$(date | awk '{print $4}')""
                                    sed -i '2s/1/2/' $FILE_TEMP;;
                                '2')
                                    led_control 2;
                                    timer 0
                                    enviar_ifttt "Se detuvo el sistema. Tiempo transcurrido: $TIEMPO_T"
                                    sed -i '2s/2/1/' $FILE_TEMP;;
                                '*')
                                    echo "El archivo temporal esta dañado o modificado incorrectamente, por favor, eliminelo";;
esac
}

main () {
           case "$1" in
                        '-c')
                            echo "Calibrando el sistema, por favor aguarde.\n ADVERTENCIA!! Es posible que se encienda el LED durante el proceso."
                            led_control $2
                            echo "Calibración finalizada";;

                        'start')
                            state_main;;

                        '*')
                            echo "Se ingresó un sub comando invalido o faltante";;

esac
}
#Script iniciador

if [ -f "$FILE_TEMP" ]; then
          echo "Iniciando script...\n"
          cargar_datos
          main $1 $2
else
          echo "El archivo temporal no existe, creando en el directorio del script..." && echo -e "    [TEMP FILE]\nSTATE_LED: 1 #Estados del led\nSTATE_COM: 1 #Estado de comunicación con IFTTT, 1 para SÍ, 0 para NO\nSTATE_TIME: 0000000 #almacen de datos de tiempo (No modificar)\n" >> "$FILE_TEMP"
     
fi