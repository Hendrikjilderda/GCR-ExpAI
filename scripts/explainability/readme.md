# README
FIXME

## Packages
Er wordt gebruik gemaakt van de volgende packages:

- DALEX
- DALEXtra


## Script *DALEX_script.R*
### Gebruik van script
Naast losse functies is er ook een script beschikbaar voor gebruik. 
Dit script maakt gebruik van de losse functies. 
Het is dus noodzakelijk dat de losse functies voor het script wordt gecalled.

### Inhoud van script
FIXME

## Functies *DALEX_functions.R*
De volgende functies zijn beschikbaar:

### Instance level

- [SHAP](https://ema.drwhy.ai/shapley.html)
    `SHAP(<case>, <explainer>)`
    
- [CP](https://ema.drwhy.ai/ceterisParibus.html)
    `CP(<case>, <explainer>)`
 
### Dataset level

- [VIP](https://ema.drwhy.ai/featureImportance.html)
    `VIP(<explainer>)`
    
- [PDP](https://ema.drwhy.ai/partialDependenceProfiles.html)
    `PDP(<variable>, <explainer>)`


