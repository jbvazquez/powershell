# powershell
PowerShell Scripts

 - existencias_cyberpuerta.ps1

## existencias_cyberpuerta
Script de verificación de existencia de un producto, obtiene el contenido de la pagina del producto en www.cyberpuerta.com
Si no existe algún objecto con la clase ``` class="emdetails_notinstocktext1" ```despliega una notificación
Esta clase es usada en divs para productos agotados.
 ### Verificación periódica automática

 - **Windows**: 
Para realizar la verificacion en un intervalo especifico se puede implementando programando una tarea en [Task Scheduler](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks).
Tutorial: [How to Automate PowerShell Scripts with Task Scheduler](https://blog.netwrix.com/2018/07/03/how-to-automate-powershell-scripts-with-task-scheduler/)
 - **Linux**
 Para realizar la ejecución periódica del script se puede implementar [crontab](https://man7.org/linux/man-pages/man5/crontab.5.html)
 