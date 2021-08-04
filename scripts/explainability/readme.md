# README
FIXME

## Packages
Er wordt gebruik gemaakt van de volgende packages:

- DALEX     # links naar reference toevoegen
- DALEXtra
- gridExtra


## Script *DALEX_script.R*
### Gebruik van script
Naast losse functies is er ook een script beschikbaar voor gebruik\n. 
Dit script maakt gebruik van de losse functies\n. 
Het is dus noodzakelijk dat de losse functies voor het script wordt gecalled.

### Inhoud van script
Dit script combineert alle functies en presenteert deze overzichtelijk in een gemeenschappelijke grafiek\n.

De volgende variabelen moeten declared zijn:     
- workflow
- dataset
- target_variable\n

- case (benodigd voor instance level explainations)
- variables (benodigd voor Ceteris-Paribus profiles)\n

- var (benodigd voor Partial Dependence Profile)\n

- label (optioneel)  
  
## Functies *DALEX_functions.R*
De volgende functies zijn beschikbaar:\n
*titel van command is tevens een hyperlink naar verder uitleg.*

- tm_explainer
`tm_explainer(<workflow>, <dataset>, <target_variable>, <label>)`




### Instance level

- [SHAP](https://ema.drwhy.ai/shapley.html)
    `SHAP(<case>, <explainer>)`
explainer -> explainer uit functie tm_explainer
    
- [CP](https://ema.drwhy.ai/ceterisParibus.html)
    `CP(<case>, <explainer>)`
explainer -> explainer uit functie tm_explainer
 
### Dataset level

- [VIP](https://ema.drwhy.ai/featureImportance.html)
    `VIP(<explainer>)`
explainer -> explainer uit functie tm_explainer
    
- [PDP](https://ema.drwhy.ai/partialDependenceProfiles.html)
    `PDP(<variable>, <explainer>)`
    
explainer -> explainer uit functie tm_explainer


