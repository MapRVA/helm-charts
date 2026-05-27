{{/*
Expand the name of the chart.
*/}}
{{- define "swapbox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "swapbox.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart name and version label.
*/}}
{{- define "swapbox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "swapbox.labels" -}}
helm.sh/chart: {{ include "swapbox.chart" . }}
{{ include "swapbox.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "swapbox.selectorLabels" -}}
app.kubernetes.io/name: {{ include "swapbox.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Hostname of the CNPG read-write service.
*/}}
{{- define "swapbox.dbHostRW" -}}
{{- printf "%s-rw" .Values.cnpg.clusterName -}}
{{- end }}

{{/*
Hostname of the CNPG read-only service.
*/}}
{{- define "swapbox.dbHostRO" -}}
{{- printf "%s-ro" .Values.cnpg.clusterName -}}
{{- end }}

{{/*
Name of the CNPG-generated app credentials Secret.
*/}}
{{- define "swapbox.dbAppSecret" -}}
{{- printf "%s-app" .Values.cnpg.clusterName -}}
{{- end }}

{{/*
Name of the CNPG-generated superuser credentials Secret.
*/}}
{{- define "swapbox.dbSuperuserSecret" -}}
{{- printf "%s-superuser" .Values.cnpg.clusterName -}}
{{- end }}

{{/*
Name of the chart-managed PostgREST credentials Secret.
*/}}
{{- define "swapbox.postgrestSecret" -}}
{{- printf "%s-postgrest" (include "swapbox.fullname" .) -}}
{{- end }}
