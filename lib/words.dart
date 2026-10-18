/// Word bank: language -> category -> words.
/// Lists don't need to line up between languages, so each one can use
/// words that are natural to draw in that language.
const wordBank = <String, Map<String, List<String>>>{
  'en': {
    'Animals': ['cat', 'dog', 'elephant', 'giraffe', 'penguin', 'crocodile', 'owl', 'snail', 'whale', 'kangaroo', 'hedgehog', 'butterfly'],
    'Food': ['pizza', 'banana', 'birthday cake', 'ice cream', 'dumplings', 'hamburger', 'pineapple', 'fried egg', 'watermelon', 'pretzel', 'carrot', 'sandwich'],
    'Jobs': ['firefighter', 'doctor', 'chef', 'pilot', 'police officer', 'hairdresser', 'astronaut', 'teacher', 'farmer', 'painter', 'dentist', 'postman'],
    'Around the house': ['umbrella', 'chair', 'lamp', 'clock', 'television', 'scissors', 'kettle', 'bathtub', 'glasses', 'toothbrush', 'key', 'bed'],
    'Places': ['beach', 'castle', 'hospital', 'airport', 'volcano', 'desert', 'circus', 'church', 'lighthouse', 'zoo', 'cinema', 'island'],
    'Transport': ['bicycle', 'airplane', 'ship', 'train', 'helicopter', 'rocket', 'scooter', 'tram', 'hot air balloon', 'submarine', 'tractor', 'ambulance'],
    'Sports and games': ['football', 'tennis', 'skiing', 'boxing', 'swimming', 'basketball', 'golf', 'archery', 'surfing', 'bowling', 'chess', 'horse riding'],
    'Fairy tales': ['dragon', 'mermaid', 'witch', 'dwarf', 'fairy', 'pirate', 'knight', 'princess', 'ghost', 'vampire', 'unicorn', 'robot'],
    'Nature': ['rainbow', 'tree', 'mushroom', 'mountain', 'cloud', 'lightning', 'sun', 'moon', 'cactus', 'waterfall', 'snowflake', 'rose'],
    'Clothing': ['hat', 'dress', 'wellies', 'tie', 'gloves', 'scarf', 'sock', 'crown', 'raincoat', 'pyjamas', 'baseball cap', 'sunglasses'],
  },
  'pl': {
    'Zwierzęta': ['kot', 'pies', 'słoń', 'żyrafa', 'pingwin', 'krokodyl', 'sowa', 'ślimak', 'wieloryb', 'kangur', 'jeż', 'motyl'],
    'Jedzenie': ['pizza', 'banan', 'tort urodzinowy', 'lody', 'pierogi', 'hamburger', 'ananas', 'jajko sadzone', 'arbuz', 'precel', 'marchewka', 'kanapka'],
    'Zawody': ['strażak', 'lekarz', 'kucharz', 'pilot', 'policjant', 'fryzjer', 'astronauta', 'nauczyciel', 'rolnik', 'malarz', 'dentysta', 'listonosz'],
    'W domu': ['parasol', 'krzesło', 'lampa', 'zegar', 'telewizor', 'nożyczki', 'czajnik', 'wanna', 'okulary', 'szczoteczka do zębów', 'klucz', 'łóżko'],
    'Miejsca': ['plaża', 'zamek', 'szpital', 'lotnisko', 'wulkan', 'pustynia', 'cyrk', 'kościół', 'latarnia morska', 'zoo', 'kino', 'wyspa'],
    'Transport': ['rower', 'samolot', 'statek', 'pociąg', 'helikopter', 'rakieta', 'hulajnoga', 'tramwaj', 'balon', 'łódź podwodna', 'traktor', 'karetka'],
    'Sport i gry': ['piłka nożna', 'tenis', 'narciarstwo', 'boks', 'pływanie', 'koszykówka', 'golf', 'łucznictwo', 'surfing', 'kręgle', 'szachy', 'jazda konna'],
    'Baśnie i bajki': ['smok', 'syrena', 'czarownica', 'krasnoludek', 'wróżka', 'pirat', 'rycerz', 'królewna', 'duch', 'wampir', 'jednorożec', 'robot'],
    'Przyroda': ['tęcza', 'drzewo', 'grzyb', 'góra', 'chmura', 'błyskawica', 'słońce', 'księżyc', 'kaktus', 'wodospad', 'płatek śniegu', 'róża'],
    'Ubrania': ['kapelusz', 'sukienka', 'kalosze', 'krawat', 'rękawiczki', 'szalik', 'skarpetka', 'korona', 'płaszcz przeciwdeszczowy', 'piżama', 'czapka z daszkiem', 'okulary przeciwsłoneczne'],
  },
};
