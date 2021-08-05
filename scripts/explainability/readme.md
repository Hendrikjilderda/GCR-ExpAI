# README
Deze repo maakt gebruik van onder andere de DALEX package om de explainability van modellen te verhogen. 
In dit model zijn twee bestanden te vinden. Een volledig script die geautomatiseerd plots maakt aan de hand van de aangegeven variabelen en losse functies waarmee soepel plots zelf kunnen worden gemaakt. Per bestand staat hieronder verdere uitleg.

Het is van belang dat deze files in dezelfde directory staan voor het importeren van de functies. 
Als deze functies al vooraf al zijn gedefineerd is dit niet nodig.


## Packages
Er wordt gebruik gemaakt van de volgende packages:

- DALEX     **links naar reference toevoegen
- DALEXtra
- gridExtra


## Script *DALEX_script.R*
### Gebruik van script
Naast losse functies is er ook een script beschikbaar voor gebruik\n. 
Het script kan eenvoudig in zijn geheel uitegevoerd worden vanuit het main.R bestand.

    setwd(path/to)
    source(./DALEX_functions.R)
    source(./DALEX_script.R)

Afhankelijk van welke variabelen er gedefineerd zijn komen er 1 of meerdere plots uit.
Deze plots worden samen met de explainer als global variables beschikbaar gemaakt voor eventuele verdere bewerking.

### Inhoud van script
Dit script combineert alle functies en presenteert deze overzichtelijk in een gemeenschappelijke grafiek\n.

De volgende variabelen moeten gedefineerd zijn:     
- workflow
- dataset
- target_variable


- case (benodigd voor instance level explainations)
- variables (benodigd voor Ceteris-Paribus profiles)\n


- var (benodigd voor Partial Dependence Profile)\n


- label (optioneel)  

  
## Functies *DALEX_functions.R*
De volgende functies zijn beschikbaar:\n
*titel van command is tevens een hyperlink naar verder uitleg.*

- tm_explainer
        tm_explainer(<fitted_model>, <dataset>, <target_variable>, <label>)
fitted_model -> fitted en predicted workflow 
dataset ->  dataset waarop het model gebaseerd is?
target_variable ->  doel variabele
label (optineel) -> naam voor het model die terug komt in de plots


### Instance level

- [SHAP](https://ema.drwhy.ai/shapley.html)
        SHAP(<case>, <explainer>)
case -> individuele case die uitgewerkt wordt
explainer -> explainer uit functie tm_explainer
    
- [CP](https://ema.drwhy.ai/ceterisParibus.html)
        CP(<case>, <explainer>)
case -> individuele case die uitgewerkt wordt
explainer -> explainer uit functie tm_explainer
 
### Dataset level

- [VIP](https://ema.drwhy.ai/featureImportance.html)
        VIP(<explainer>)
explainer -> explainer uit functie tm_explainer
    
- [PDP](https://ema.drwhy.ai/partialDependenceProfiles.html)
        PDP(<variable>, <explainer>)
    explainer -> explainer uit functie tm_explainer

