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
local function insertElement(evt, obj)
-- On vérifie le paramètre obj.
if obj then
if type(obj) ~= "table" then
obj = getmetatable(obj)
end
end
-- Création d'une variable locale pour le premier paramètre de Dialogs.chooseOne.
local message = obj == nil and "Choisissez la fonction LUA que vous souhaitez insérer" or "Choisissez la propriété ou méthode que vous souhaitez insérer";
-- Création d'une variable locale pour le second paramètre de Dialogs.chooseOne.
local title = obj == nil and "Insérer une fonction depuis le builtin de LUA" or "Insérez une propriété ou méthode";
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
-- Création d'une variable locale pour le quatrième et dernier paramètre de Dialogs.chooseOne, il s'agit de l'index de l'élément qui sera sélectionné par défaut.
local selection = 1;
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
"string",
"utf8"
};
-- Création d'une variable locale pour le quatrième et dernier paramètre de Dialogs.chooseOne, il s'agit de l'index de l'élément qui sera sélectionné par défaut..
local selection = 1;
-- C'est bon, on peut afficher la boîte de dialogue chooseOne.
local chooseAnElement = Dialogs.chooseOne(message, title, options, selection);
if chooseAnElement then -- Si l'on a pas pressé sur Echappe ou validé le bouton annuler.
local element = options[chooseAnElement];
-- Initialisation d'une variable locale obj à nil.
local obj = nil;
-- Si l'utilisateur choisi d'insérer une fonction globale du builtin, on exécute le traitement ci-dessous.
if chooseAnElement == 1 then
-- On insère l'élément, cependant, le paramètre obj n'est pas passé à la fonction insertElement, uniquement pour les fonctions du builtin.
insertElement(evt);
-- Les traitements ci-dessous vont affecter une valeur à la variable locale obj, selon l'élément choisi par l'utilisateur.
elseif chooseAnElement == 2 then
obj = app;
elseif chooseAnElement == 3 then
obj = CommandEvent;
elseif chooseAnElement == 4 then
obj = Dialogs;
elseif chooseAnElement == 5 then
obj = Document;
elseif chooseAnElement == 6 then
obj = Event;
elseif chooseAnElement == 7 then
obj = EventHandler;
elseif chooseAnElement == 8 then
obj = InputStream;
elseif chooseAnElement == 9 then
obj = KeyEvent;
elseif chooseAnElement == 10 then
obj = Menu;
elseif chooseAnElement == 11 then
obj = MenuBar;
elseif chooseAnElement == 12 then
obj = MenuItem;
elseif chooseAnElement == 13 then
obj = MouseEvent;
elseif chooseAnElement == 14 then
obj = OutputStream;
elseif chooseAnElement == 15 then
obj = Path;
elseif chooseAnElement == 16 then
obj = Process;
elseif chooseAnElement == 17 then
obj = ProcessEvent;
elseif chooseAnElement == 18 then
obj = TextEditor;
elseif chooseAnElement == 19 then
obj = Timer;
elseif chooseAnElement == 20 then
obj = WebRequest;
elseif chooseAnElement == 21 then
obj = WebResponse;
elseif chooseAnElement == 22 then
obj = io;
elseif chooseAnElement == 23 then
obj = string;
elseif chooseAnElement == 24 then
obj = utf8;
end
-- On insère l'élément, le paramètre obj est passé cette fois-ci, pour les autres cas de figure.
insertElement(evt, obj);
end
end

-- On affecte la fonction qui va gérer la validation sur l'item de menu. 
insertElementItem:bind(function(evt)
chooseElementTypeToInsert(evt);
end);
evt:getDocument():bindAccelerator("ctrl+i", chooseElementTypeToInsert);
end);