{{- define "bulwark.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "bulwark.fullname" -}}
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

{{- define "bulwark.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "bulwark.labels" -}}
helm.sh/chart: {{ include "bulwark.chart" . }}
{{ include "bulwark.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "bulwark.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bulwark.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "bulwark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bulwark.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "bulwark.sessionSecretName" -}}
{{- if .Values.sessionSecret.existingSecret }}
{{- .Values.sessionSecret.existingSecret }}
{{- else }}
{{- printf "%s-session" (include "bulwark.fullname" .) }}
{{- end }}
{{- end }}
