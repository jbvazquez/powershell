##########################################################################
# Created: 2021/01/21 13:20:01
# Last modified: 2021/01/21 14:54:22
# File   : existencias_cyberpuertta.ps1
# Author : Jose Becerra
# Description : Este script hace una solictiud a la pagina del producto en cyberpuerta
# Si no existe la clase "emdetails_notinstocktext1" usada en divs para productos agotados
# desplegar una notificacion
#
# Example: Usage: existencias_cyberpuertta.ps1
#
# Change History
# Date          Author      			Version    	Description of Change
# 2021/01/21    Jose Becerra			1.0.0		Initial Release
###########################################################################

function Check-Stock {
    $url = "https://www.cyberpuerta.mx/Computo-Hardware/Componentes/Tarjetas-de-Video/Tarjeta-de-Video-AORUS-NVIDIA-GeForce-RTX-3070-Master-8GB-256-bit-GDDR6-PCI-Express-x16-4-0.html"
    $WebResponse = Invoke-WebRequest $url
    $ParsedHtml = $WebResponse.ParsedHtml
    $NoStockDivs = $ParsedHtml.body.getElementsByClassName("emdetails_notinstocktext1")
    if ($NoStockDivs.length -eq 0) {
        $products = $ParsedHtml.body.getElementsByClassName("detailsInfo_right_title")
        $productName = $products[0].innerHTML.ToString()
        Add-Type -AssemblyName PresentationFramework
        $msgBoxInput = [System.Windows.MessageBox]::Show("Nueva  Existencia `n`n$productName `n`nAbrir Enlace `n$url", 'Info', 'YesNoCancel', 'Info')
        switch ($msgBoxInput) {

            'Yes' {

                ## Do something 
                [system.Diagnostics.Process]::Start("chrome", $url)

            }

            'No' {

                ## Do something
                Exit

            }
        }
    }
}
#$NoStockDivs | foreach {write-host $_.textContent}
#$NoStockDivs.length
Check-Stock