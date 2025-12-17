-- Create songs table
CREATE TABLE songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    artist TEXT NOT NULL,
    year INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create players table
CREATE TABLE players (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    avatar_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create progress table
CREATE TABLE progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_id INTEGER NOT NULL,
    song_id INTEGER NOT NULL,
    completion_percentage INTEGER DEFAULT 0,
    completed_at DATETIME,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES players(id),
    FOREIGN KEY (song_id) REFERENCES songs(id),
    UNIQUE(player_id, song_id)
);

-- Insert default players
INSERT INTO players (name) VALUES ('Garrett');
INSERT INTO players (name) VALUES ('Owen');

-- Insert songs
INSERT INTO songs (title, artist, year) VALUES
('Psycho Killer', 'Talking Heads', 1977),
('Crazy Train', 'Ozzy Osbourne', 1980),
('Bad Moon Rising', 'CCR', 1969),
('Zombie', 'The Cranberries', 1994),
('Where Is My Mind', 'The Pixies', 1988),
('With Or Without You', 'U2', 1987),
('21 Guns', 'Green Day', 2009),
('Another Brick In The Wall', 'Pink Floyd', 1980),
('House Of The Rising Sun', 'The Animals', 1964),
('All My Loving', 'The Beatles', 1963),
('Otherside', 'Red Hot Chili Peppers', 1999),
('Roxanne', 'The Police', 1978),
('Gimme Some Lovin''', 'Spencer Davis Group', 1966),
('Sunshine Of Your Love', 'Cream', 1967),
('My Girl', 'Temptations', 1964),
('Yellow', 'Coldplay', 2000),
('Stand By Me', 'Ben E. King', 1961),
('Come As You Are', 'Nirvana', 1991),
('Seven Nation Army', 'White Stripes', 2003),
('Thunderstruck', 'AC/DC', 1990),
('Blitzkrieg Bop', 'Ramones', 1976),
('Have You Ever Seen The Rain', 'CCR', 1970),
('Money', 'Pink Floyd', 1973),
('Livin'' On A Prayer', 'Bon Jovi', 1986),
('Come Together', 'The Beatles', 1969),
('Three Little Birds', 'Bob Marley', 1977),
('Should I Stay Or Should I Go', 'The Clash', 1982),
('Crazy Little Thing Called Love', 'Queen', 1979),
('The Chain', 'Fleetwood Mac', 1977),
('I Got You (I Feel Good)', 'James Brown', 1965),
('Ironman', 'Black Sabbath', 1971),
('Under Pressure', 'Queen/Bowie', 1981),
('Give It Away', 'Red Hot Chili Peppers', 1991),
('Hey Joe', 'Jimi Hendrix', 1967),
('Another One Bites The Dust', 'Queen', 1980),
('September', 'Earth, Wind & Fire', 1978),
('Smoke On The Water', 'Deep Purple', 1972),
('Feel Good Inc.', 'Gorillaz', 2005),
('Enter Sandman', 'Metallica', 1991),
('Creep', 'Radiohead', 1993),
('Don''t Stop Believin''', 'Journey', 1981),
('Smells Like Teen Spirit', 'Nirvana', 1991),
('Good Times', 'Chic', 1974),
('Are You Gonna Be My Girl', 'Jet', 2003),
('Sweet Child O'' Mine', 'Guns N'' Roses', 1987),
('Something', 'The Beatles', 1969),
('Killing In The Name', 'Rage Against The Machine', 1992),
('Under The Bridge', 'Red Hot Chili Peppers', 1991),
('Billie Jean', 'Michael Jackson', 1982),
('Hysteria', 'Muse', 2003);