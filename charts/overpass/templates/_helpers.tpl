{{- define "overpass.dataHash" -}}
{{- $init := dict
  "revision" (.Values.storage.revision | default "1")
  "planetUrl" .Values.overpass.planetUrl
  "diffUrl" .Values.overpass.diffUrl
  "meta" .Values.overpass.meta
  "planetPreprocess" (.Values.overpass.planetPreprocess | default "")
  "diffPreprocess" (.Values.overpass.diffPreprocess | default "")
  "imageTag" .Values.image.tag
-}}
{{- $init | toJson | sha256sum | trunc 8 -}}
{{- end -}}
