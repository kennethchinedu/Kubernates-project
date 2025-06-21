{{/*
Expand the name of the chart.
*/}}
{{- define "recipe-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}




{{- define "recipe-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 |  trimSuffix "-" -}}
{{- end -}} 

#Defining backend and frontend app names
{{- define "recipe-app.backendContainer" -}}
{{- printf "%s-%s" .Chart.Name "backend-app" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "recipe-app.frontendContainer" -}}
{{- printf "%s-%s" .Release.Name "frontend-app" | trunc 63 | trimSuffix "-" -}}
{{- end -}}






{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "recipe-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "recipe-app.labels" -}}
chart: {{ include "recipe-app.chart" . }}
{{ include "recipe-app.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "recipe-app.selectorLabels" -}}
name: {{ include "recipe-app.name" . }}
{{- end }}

{{- define "backend.selectorLabels" -}}
app-name: {{ printf "%s-backend" (include "recipe-app.name" .) }}
{{- end }}

{{- define "frontend.selectorLabels" -}}
app-name: {{ printf "%s-frontend" (include "recipe-app.name" .) }}
{{- end }}


{{/*}}
Selector labels for frontend and backend
*/}}




{{/*
Create the name of the service account to use
*/}}
{{- define "recipe-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "recipe-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
