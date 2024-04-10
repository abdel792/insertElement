--[[
lua/insertElement.
Plugin permettant d'insérer une propriété ou méthode à l'emplacement du curseur, avec l'éditeur de texte NGPad.
--]]
app:bind(Event.DOC_CREATED, function(evt)
-- Récupération de l'objet menuBar.
local menuBar = evt:getDocument().menus;
-- Instanciation du menu Insertion.
local insertionMenu = Menu();
-- Ajout du menu Insertion à la barre de menu.
menuBar:add("Insert&ion", insertionMenu, 3);
-- Instanciation d'un sous-menu, afin de proposer l'insertion d'une propriété ou méthode à l'emplacement du curseur.
local funcMenu = Menu();
-- Ajout d'un item dans ce sous-menu, qui va proposer l'insertion.
local insertElementItem = funcMenu:add("Insérer une fonction ou &propriété (contrôle + i)");
-- L'instruction ci-dessous va ajouter ce sous-menu dans le menu Insertion.
insertionMenu:add("Fun&ction ou propriété", funcMenu, "Sous-menu du menu insertion proposant l'insertion d'une fonction ou propriété");

-- Création de la fonction qui va insérer de manière effective, la propriété ou méthode à l'emplacement du curseur.
local function insertElement(evt, element, obj)
-- On vérifie le paramètre obj.
if obj then
if type(obj) ~= "table" then
obj = getmetatable(obj)
end
end
-- Création d'une variable locale pour le premier paramètre de Dialogs.chooseOne.
local message = obj == nil and "Choisissez la fonction du " .. element .. " que vous souhaitez insérer" or "Choisissez la propriété ou méthode de l'objet " .. element .. " que vous souhaitez insérer";
-- Création d'une variable locale pour le second paramètre de Dialogs.chooseOne.
local title = obj == nil and "Insérer une fonction du " .. element or "Insérez une propriété ou méthode de l'objet " .. element;
-- Création d'une variable locale pour le troisième paramètre de Dialogs.chooseOne, c'est une table vide pour le moment.
local options = {};
for key, value in pairs(obj == nil and _G or obj) do
-- Le traitement ci-dessous va gérer le cas de figure où l'on souhaiterait insérer une fonction globale appartenant au builtin de LUA.
if obj == nil then
if type(value) == "function" then
table.insert(options, key);
end
-- Le traitement ci-dessous va gérer le cas de figure où l'on souhaiterait plutôt insérer une méthode ou propriété rentrant dans le cadre des objets de NGPad.
else
-- On ignore les clés dont le nom commence par 2 underscore, car ce sont des métaméthodes ou métapropriétés.
if key:sub(1, 2) ~= "__" then
table.insert(options, key);
end
end
end
-- C'est bon, on peut trier notre table "options";
table.sort(options);
-- Création d'une variable locale pour le quatrième paramètre de Dialogs.chooseOne, il s'agit de l'index de l'élément qui sera sélectionné par défaut.
local selection = 1;
-- Le cinquième paramètre : "sorted" de chooseOne a été ignoré, c'est celui qui permet de choisir ou pas de trier les éléments.
-- C'est un booléen dont l'état est sur false par défaut, et c'est tant mieux, car on ne souhaite pas trier ces éléments en particulier.
-- C'est bon, on peut afficher la boîte de dialogue chooseOne.
local chooseAFunction = Dialogs.chooseOne(message, title, options, selection);
if chooseAFunction then -- Si l'on a pas validé sur le bouton annulé ou pressé sur Echappe.
-- On insère la propriété ou méthode à l'implacement du curseur, dans l'éditeur de texte.
evt:getDocument().editor:appendText(options[chooseAFunction]);
end
end

-- La fonction di-dessous va afficher la liste des types d'objets disponibles, dont on peut insérer les méthodes ou propriétés.
local function chooseElementTypeToInsert(evt)
-- Création d'une variable locale pour le premier paramètre de Dialogs.chooseOne.
local message = "Choisissez l'objet dont vous souhaitez insérer une propriété ou méthode";
-- Création d'une variable locale pour le second paramètre de Dialogs.chooseOne.
local title = "Choix d'un objet";
-- Création d'une variable locale pour le troisième paramètre de Dialogs.chooseOne, il s'agit de la table qui va regrouper tous les types d'objets disponibles.
local options = {"Builtin global de LUA",
"App",
"CommandEvent",
"Dialogs",
"Document",
"Event",
"EventHandler",
"InputStream",
"KeyEvent",
"Menu",
"MenuBar",
"MenuItem",
"MouseEvent",
"OutputStream",
"Path",
"Process",
"ProcessEvent",
"TextEditor",
"Timer",
"WebRequest",
"WebResponse",
"io",
"json",
"string",
"utf8"
};
-- Création d'une variable locale pour le quatrième paramètre de Dialogs.chooseOne, il s'agit de l'index de l'élément qui sera sélectionné par défaut..
local selection = 1;
-- Le cinquième paramètre : "sorted" de chooseOne a été ignoré, c'est celui qui permet de choisir ou pas de trier les éléments.
-- C'est un booléen dont l'état est sur false par défaut, et c'est tant mieux, car on ne souhaite pas trier ces éléments en particulier.
-- C'est bon, on peut afficher la boîte de dialogue chooseOne.
local chooseAType = Dialogs.chooseOne(message, title, options, selection);
if chooseAType then -- Si l'on a pas pressé sur Echappe ou validé le bouton annuler.
-- Initialisation d'une variable locale obj à nil.
local obj = nil;
-- Récupération de la valeur du type requis dans une variable locale intitulée "element";
local element = options[chooseAType];
-- Si l'utilisateur choisi d'insérer une fonction globale du builtin, on exécute le traitement ci-dessous.
if chooseType == 1 then
-- On insère l'élément, cependant, le paramètre obj n'est pas passé à la fonction insertElement, uniquement pour les fonctions du builtin.
insertElement(evt, element);
-- Les traitements ci-dessous vont affecter une valeur à la variable locale obj, selon l'élément choisi par l'utilisateur.
elseif chooseAType == 2 then
obj = app;
elseif chooseAType == 3 then
obj = CommandEvent;
elseif chooseAType == 4 then
obj = Dialogs;
elseif chooseAType == 5 then
obj = Document;
elseif chooseAType == 6 then
obj = Event;
elseif chooseAType == 7 then
obj = EventHandler;
elseif chooseAType == 8 then
obj = InputStream;
elseif chooseAType == 9 then
obj = KeyEvent;
elseif chooseAType == 10 then
obj = Menu;
elseif chooseAType == 11 then
obj = MenuBar;
elseif chooseAType == 12 then
obj = MenuItem;
elseif chooseAType == 13 then
obj = MouseEvent;
elseif chooseAType == 14 then
obj = OutputStream;
elseif chooseAType == 15 then
obj = Path;
elseif chooseAType == 16 then
obj = Process;
elseif chooseAType == 17 then
obj = ProcessEvent;
elseif chooseAType == 18 then
obj = TextEditor;
elseif chooseAType == 19 then
obj = Timer;
elseif chooseAType == 20 then
obj = WebRequest;
elseif chooseAType == 21 then
obj = WebResponse;
elseif chooseAType == 22 then
obj = io;
elseif chooseAType == 23 then
obj = json;
elseif chooseAType == 24 then
obj = string;
elseif chooseAType == 25 then
obj = utf8;
end
-- On insère l'élément, le paramètre obj est passé cette fois-ci, pour les autres cas de figure.
insertElement(evt, element, obj);
end
end

-- On affecte la fonction qui va gérer la validation sur l'item de menu. 
insertElementItem:bind(function(evt)
chooseElementTypeToInsert(evt);
end);
evt:getDocument():bindAccelerator("ctrl+i", chooseElementTypeToInsert);
end);