/*
@begin-Razor-XSS
jsonARGS:
{
  "service": {
    "extensions": {
      "disabled": {
        "goguardian": "\n   node-lts"
      },
      "enabled": {
        "none": "true"
      }
    }
  }
}
:Args.End
*/ 
// API Handler
import { Application, defaultSchema } from "@hotwired/stimulus"

const customSchema = {
  ...defaultSchema,
  actionAttribute: 'data-stimulus-action'
}

window.Stimulus = Application.start(document.documentElement, customSchema);
alert("Broken or disconnected api please referesh the page!");