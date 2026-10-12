class ContentItem {
  const ContentItem({
    required this.id,
    required this.title,
    required this.genre,
    required this.developer,
    required this.releaseYear,
    required this.rating,
    required this.description,
    required this.fullDescription,
    required this.image,
  });

  final int id;
  final String title;
  final String genre;
  final String developer;
  final int releaseYear;
  final double rating;
  final String description;
  final String fullDescription;
  final String image;
}

const List<ContentItem> contentItems = [
  ContentItem(
    id: 1,
    title: 'The Witcher 3: Wild Hunt',
    genre: 'RPG',
    developer: 'CD Projekt Red',
    releaseYear: 2015,
    rating: 9.8,
    description: 'Ролевая игра о ведьмаке Геральте в огромном открытом мире.',
    fullDescription:
        'The Witcher 3: Wild Hunt — ролевая игра от студии CD Projekt Red, '
        'третья часть приключений ведьмака Геральта из Ривии. Игрока ждёт '
        'огромный открытый мир, десятки побочных квестов, система алхимии и '
        'знаков, а также мрачная славянская фэнтези-атмосфера. Игра получила '
        'звание одной из лучших RPG в истории и множество наград «Игра года».',
    image: 'assets/images/witcher3.jpg',
  ),
  ContentItem(
    id: 2,
    title: 'Red Dead Redemption 2',
    genre: 'Action-Adventure',
    developer: 'Rockstar Games',
    releaseYear: 2018,
    rating: 9.7,
    description: 'История банды на Диком Западе в 1899 году.',
    fullDescription:
        'Red Dead Redemption 2 — приключенческий боевик от Rockstar Games, '
        'приквел к первой части. Действие разворачивается на Диком Западе в '
        '1899 году, а игрок в роли Артура Моргана состоит в банде Ван дер '
        'Линде. Игра известна детализированным живым миром, глубоким сюжетом '
        'и высокой проработкой мелочей.',
    image: 'assets/images/rdr2.jpg',
  ),
  ContentItem(
    id: 3,
    title: 'Cyberpunk 2077',
    genre: 'RPG',
    developer: 'CD Projekt Red',
    releaseYear: 2020,
    rating: 8.5,
    description: 'Киберпанк-ролевая игра в мегаполисе Найт-Сити.',
    fullDescription:
        'Cyberpunk 2077 — ролевая игра в жанре киберпанк от CD Projekt Red по '
        'мотивам настольной игры Cyberpunk 2020. События происходят в '
        'мегаполисе Найт-Сити, где игрок создаёт наёмника V и борется за '
        'выживание вместе с легендарным Джонни Сильверхендом. Проект сочетает '
        'открытый мир, прокачку имплантов и вариативность прохождения.',
    image: 'assets/images/cyberpunk2077.jpg',
  ),
  ContentItem(
    id: 4,
    title: 'Grand Theft Auto V',
    genre: 'Action-Adventure',
    developer: 'Rockstar Games',
    releaseYear: 2013,
    rating: 9.5,
    description: 'Три грабителя в открытом городе Лос-Сантос.',
    fullDescription:
        'Grand Theft Auto V — приключенческий боевик с открытым миром от '
        'Rockstar Games. Игрок управляет тремя грабителями — Майклом, '
        'Франклином и Тревором — в вымышленном городе Лос-Сантос. Игра '
        'предлагает десятки миссий, множество побочных занятий и режим '
        'GTA Online.',
    image: 'assets/images/gta5.jpg',
  ),
  ContentItem(
    id: 5,
    title: 'Minecraft',
    genre: 'Sandbox',
    developer: 'Mojang Studios',
    releaseYear: 2011,
    rating: 9.0,
    description: 'Блочная песочница с бесконечным процедурным миром.',
    fullDescription:
        'Minecraft — песочница от Mojang Studios, в которой мир состоит из '
        'блоков. Игрок может добывать ресурсы, строить и исследовать '
        'бесконечный процедурно генерируемый мир в режимах выживания или '
        'творчества. Благодаря простым правилам и огромной свободе действий '
        'Minecraft стала самой продаваемой игрой в истории.',
    image: 'assets/images/minecraft.jpg',
  ),
];
