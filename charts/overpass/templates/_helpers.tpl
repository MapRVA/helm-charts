{{- define "overpass.dataHash" -}}
{{- $init := dict
  "revision" (.Values.storage.revision | default "1")
  "initMode" .Values.overpass.init.mode
  "dataSource" .Values.overpass.init.dataSource
  "cloneSource" .Values.overpass.init.cloneSource
  "compressionMethod" .Values.overpass.init.compressionMethod
  "diffUrl" .Values.overpass.diffUrl
  "metaMode" .Values.overpass.metaMode
  "imageTag" .Values.image.tag
-}}
{{- $init | toJson | sha256sum | trunc 8 -}}
{{- end -}}
