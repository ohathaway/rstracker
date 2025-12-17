-- Add ordinal field to track difficulty order (easiest to hardest)
ALTER TABLE songs ADD COLUMN ordinal INTEGER;

-- Update songs with their ordinal position from the original list (easiest to hardest)
UPDATE songs SET ordinal = 1 WHERE title = 'Psycho Killer' AND artist = 'Talking Heads';
UPDATE songs SET ordinal = 2 WHERE title = 'Crazy Train' AND artist = 'Ozzy Osbourne';
UPDATE songs SET ordinal = 3 WHERE title = 'Bad Moon Rising' AND artist = 'CCR';
UPDATE songs SET ordinal = 4 WHERE title = 'Zombie' AND artist = 'The Cranberries';
UPDATE songs SET ordinal = 5 WHERE title = 'Where Is My Mind' AND artist = 'The Pixies';
UPDATE songs SET ordinal = 6 WHERE title = 'With Or Without You' AND artist = 'U2';
UPDATE songs SET ordinal = 7 WHERE title = '21 Guns' AND artist = 'Green Day';
UPDATE songs SET ordinal = 8 WHERE title = 'Another Brick In The Wall' AND artist = 'Pink Floyd';
UPDATE songs SET ordinal = 9 WHERE title = 'House Of The Rising Sun' AND artist = 'The Animals';
UPDATE songs SET ordinal = 10 WHERE title = 'All My Loving' AND artist = 'The Beatles';
UPDATE songs SET ordinal = 11 WHERE title = 'Otherside' AND artist = 'Red Hot Chili Peppers';
UPDATE songs SET ordinal = 12 WHERE title = 'Roxanne' AND artist = 'The Police';
UPDATE songs SET ordinal = 13 WHERE title = 'Gimme Some Lovin''' AND artist = 'Spencer Davis Group';
UPDATE songs SET ordinal = 14 WHERE title = 'Sunshine Of Your Love' AND artist = 'Cream';
UPDATE songs SET ordinal = 15 WHERE title = 'My Girl' AND artist = 'Temptations';
UPDATE songs SET ordinal = 16 WHERE title = 'Yellow' AND artist = 'Coldplay';
UPDATE songs SET ordinal = 17 WHERE title = 'Stand By Me' AND artist = 'Ben E. King';
UPDATE songs SET ordinal = 18 WHERE title = 'Come As You Are' AND artist = 'Nirvana';
UPDATE songs SET ordinal = 19 WHERE title = 'Seven Nation Army' AND artist = 'White Stripes';
UPDATE songs SET ordinal = 20 WHERE title = 'Thunderstruck' AND artist = 'AC/DC';
UPDATE songs SET ordinal = 21 WHERE title = 'Blitzkrieg Bop' AND artist = 'Ramones';
UPDATE songs SET ordinal = 22 WHERE title = 'Have You Ever Seen The Rain' AND artist = 'CCR';
UPDATE songs SET ordinal = 23 WHERE title = 'Money' AND artist = 'Pink Floyd';
UPDATE songs SET ordinal = 24 WHERE title = 'Livin'' On A Prayer' AND artist = 'Bon Jovi';
UPDATE songs SET ordinal = 25 WHERE title = 'Come Together' AND artist = 'The Beatles';
UPDATE songs SET ordinal = 26 WHERE title = 'Three Little Birds' AND artist = 'Bob Marley';
UPDATE songs SET ordinal = 27 WHERE title = 'Should I Stay Or Should I Go' AND artist = 'The Clash';
UPDATE songs SET ordinal = 28 WHERE title = 'Crazy Little Thing Called Love' AND artist = 'Queen';
UPDATE songs SET ordinal = 29 WHERE title = 'The Chain' AND artist = 'Fleetwood Mac';
UPDATE songs SET ordinal = 30 WHERE title = 'I Got You (I Feel Good)' AND artist = 'James Brown';
UPDATE songs SET ordinal = 31 WHERE title = 'Ironman' AND artist = 'Black Sabbath';
UPDATE songs SET ordinal = 32 WHERE title = 'Under Pressure' AND artist = 'Queen/Bowie';
UPDATE songs SET ordinal = 33 WHERE title = 'Give It Away' AND artist = 'Red Hot Chili Peppers';
UPDATE songs SET ordinal = 34 WHERE title = 'Hey Joe' AND artist = 'Jimi Hendrix';
UPDATE songs SET ordinal = 35 WHERE title = 'Another One Bites The Dust' AND artist = 'Queen';
UPDATE songs SET ordinal = 36 WHERE title = 'September' AND artist = 'Earth, Wind & Fire';
UPDATE songs SET ordinal = 37 WHERE title = 'Smoke On The Water' AND artist = 'Deep Purple';
UPDATE songs SET ordinal = 38 WHERE title = 'Feel Good Inc.' AND artist = 'Gorillaz';
UPDATE songs SET ordinal = 39 WHERE title = 'Enter Sandman' AND artist = 'Metallica';
UPDATE songs SET ordinal = 40 WHERE title = 'Creep' AND artist = 'Radiohead';
UPDATE songs SET ordinal = 41 WHERE title = 'Don''t Stop Believin''' AND artist = 'Journey';
UPDATE songs SET ordinal = 42 WHERE title = 'Smells Like Teen Spirit' AND artist = 'Nirvana';
UPDATE songs SET ordinal = 43 WHERE title = 'Good Times' AND artist = 'Chic';
UPDATE songs SET ordinal = 44 WHERE title = 'Are You Gonna Be My Girl' AND artist = 'Jet';
UPDATE songs SET ordinal = 45 WHERE title = 'Sweet Child O'' Mine' AND artist = 'Guns N'' Roses';
UPDATE songs SET ordinal = 46 WHERE title = 'Something' AND artist = 'The Beatles';
UPDATE songs SET ordinal = 47 WHERE title = 'Killing In The Name' AND artist = 'Rage Against The Machine';
UPDATE songs SET ordinal = 48 WHERE title = 'Under The Bridge' AND artist = 'Red Hot Chili Peppers';
UPDATE songs SET ordinal = 49 WHERE title = 'Billie Jean' AND artist = 'Michael Jackson';
UPDATE songs SET ordinal = 50 WHERE title = 'Hysteria' AND artist = 'Muse';

-- Add index for ordinal field for better performance
CREATE INDEX IF NOT EXISTS idx_songs_ordinal ON songs(ordinal);