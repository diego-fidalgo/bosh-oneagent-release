$drainLogFile = "/var/vcap/sys/log/dynatrace-oneagent-windows/drain.log"

Write-Output 'die' | Out-File -Encoding utf8 /var/vcap/jobs/dynatrace-oneagent-windows/exit

$dynatraceServiceName = "Dynatrace OneAgent"

Start-Sleep -s 5

#wait for start.ps1 to uninstall Dynatrace OneAgent
do {
	Start-Sleep -s 3
	$output = Get-Service | Where-Object {$_.Name -match "$dynatraceServiceName"}
} while ($output.length -ne 0 -and $output.Status -eq 'Running')

Start-Sleep -s 15

if ((Get-Service -Name "${dynatraceServiceName}").Status -ne "Running") {
    echo "$(Get-Date): service '${dynatraceServiceName}' not running" >> $LOGFILE
    echo "0"
    Exit 0
}

If ((Get-Service dynatrace-oneagent-windows).Status -eq "Running") {
    Write-Output 'failed' | Out-File -Encoding utf8 $drainLogFile
} Else {
    Write-Output 'success' | Out-File -Encoding utf8 $drainLogFile
}

Exit 0
