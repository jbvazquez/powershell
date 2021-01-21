# powershell
PowerShell Scripts

 - existencias_cyberpuertta.ps1

## existencias_cyberpuertta
Script de verificacion de existencia, obtiene el contenido de la pagina del producto en www.cyberpuerta.com 
Si no existe algun objecto con la clase "emdetails_notinstocktext1" despleiga una notificacion.
Esta clasee es usada en divs para productos agotados.
 ### Verificacion periodica automatica

 - **Windows**: 
Para realizar la verificacion en un intervalo especifico se puede implementando programando una tarea en [Task Scheduler](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks).
Tutorial: [How to Automate PowerShell Scripts with Task Scheduler](https://blog.netwrix.com/2018/07/03/how-to-automate-powershell-scripts-with-task-scheduler/)
 - **Linux**
 Para realizar la ejecucion periodica del script se puede implementat [crontab](https://man7.org/linux/man-pages/man5/crontab.5.html)
 