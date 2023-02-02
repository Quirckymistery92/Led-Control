# Led-Control
"Led Control" es una integración de los GPIO de un botón y un LED de OpenWrt, para un uso independiente, en base en el uso de Arduino sin comunicación SDA. COMPATIBLE CON IFTTT


Para un uso fuera de OpenWrt, usa "#/bin/bash" al inicio del script.

# Requisitos:
Sleep
OpenSSH

# Uso

Coloca el git dentro de /root y ejecutalo para las siguientes configuraciones

/bin/sh /root/led_control.sh start #Ejecuta el Script y hace un timer de 3 pulsos para el LED "LAN" & luego de haber hecho el de 3 pulsos, cambia automaticamente para 2 pulsos (intervalo entre 3 y 2 pulsos automaticos [Usando un archivo TEMP])

/bin/sh /root/led_control.sh -c 3 #Enciende y apaga el LED las determinadas veces (Cambia el numero delante de "-c" para cambiar las veces que se repita el encenido del LED)

#Modifique el archivo temporal solo para configuraciones que necesite (configuracion IFTTT)
En caso de fallas borre el archivo temporal


# COMO USAR IFTTT INTEGRADO:

Primero edite el script en la sección de la función "enviar_ifttt" para poner su WebHook (link) obtenido por IFTTT
https://domoticasa.net/guia-completa-de-ifttt-para-domotica/

Puede utilizarlo para una amplica variedad en su output de IFTTT, en el caso nativo, puede optar para que muestre una notificación en su dispositivo.
La primera notificación muestra que el sistema inició con el horario en formato HH:MM:SS. Para la segunda notificación (apagado), muestra la finalización del sistema con el horario transcurrido en formato HH:MM:SS.

Estas configuraciones pueden ser modificadas para que usted envie un mensaje personalizado
