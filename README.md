# VUT FEKT DeltaBot

Projekt který vznikl díky soutěži FEKTTeams 2024. Cílem bylo sestavit vlastní konstrukci robota typu delta a zprovoznit ho pomocí PLC od firmy 
B&R. Projekt dále pokračuje v rámci bakalářských a diplomových prací.

![Ukázka 3D modelu Delta robota](https://www.vut.cz/i/media/document_images/fotogalerie_doc/ostra/275206/2_delta_1_1600.png)

Autoři projektu DeltaBot:
 - Bc. Kryštof Doležal
 - Bc. Oliver Drga
 - Bc. Ondřej Dušek
 - Bc. Vít Fousek

 Tato diplomová práce se zabývá detekcí kolizí robotů a jejich řešením.Obsahuje původní funkční program PLC vytvořený pro bakalářku **Řízení pohybu DeltaBotu *(Vít Fousek)***, která je přepsaná na novější jádro AS runtime 6. Pro rešerši vzniku kolizí a jsou použity modely vypočítané v Matlabu z práce **Analytické modelování delta robota *(Ondřej Dušek)***, které jsou upraveny tak, aby mohli být zobrazeny dva modely deltabotu vedle sebe a jejich vzájemná pozice.

 Do budoucna je vhodné zvážit možnost propojení programu PLC přímo s Matlabem, čímž se zabývala práce **Komunikační prostředí mezi Matlab a PLC B&R pro řízení delta robota *(Kryštof Doležal)***. Propojení Matlabu a PLC by mohlo ulehčit detekci kolizí a posílat příkazy pro jejich řešení.