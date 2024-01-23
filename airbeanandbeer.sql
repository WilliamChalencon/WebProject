-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 12 jan. 2024 à 13:18
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `airbeanandbeer`
--

-- --------------------------------------------------------

--
-- Structure de la table `avis`
--

DROP TABLE IF EXISTS `avis`;
CREATE TABLE IF NOT EXISTS `avis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `utilisateur` varchar(250) NOT NULL,
  `note` int NOT NULL DEFAULT '5',
  `commentaire` varchar(2000) DEFAULT NULL,
  `bien` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `utilisateur_FK` (`utilisateur`),
  KEY `bien_FK` (`bien`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `avis`
--

INSERT INTO `avis` (`id`, `utilisateur`, `note`, `commentaire`, `bien`) VALUES
(1, 'jules@email.com', 3, 'moyen, peu d\'espace', 'Residence petit'),
(15, 'Utilisateur@mail.fr', 4, 'Le plein d\'air!', 'Résidence Le bon air'),
(16, 'Utilisateur@mail.fr', 2, 'Pas ouf!', 'Residence truc much'),
(13, 'Utilisateur@mail.fr', 5, 'Parfait', 'Résidence Lillys'),
(14, 'Utilisateur@mail.fr', 4, 'Bien', 'Résidence Lillys'),
(12, 'Utilisateur@mail.fr', 5, 'Très bon accueil!', 'Résidence Lillys'),
(10, 'Utilisateur@mail.fr', 4, 'ok', 'Résidence Lillys'),
(17, 'Utilisateur@mail.fr', 4, 'Bien situé.', 'Residence de la mer'),
(18, 'Utilisateur@mail.fr', 3, 'Grand mais loin', 'Residence des grands'),
(19, 'Utilisateur@mail.fr', 5, 'Très beau.', 'Residence grands vents'),
(20, 'Utilisateur@mail.fr', 2, 'petit', 'Residence petit');

-- --------------------------------------------------------

--
-- Structure de la table `biens`
--

DROP TABLE IF EXISTS `biens`;
CREATE TABLE IF NOT EXISTS `biens` (
  `idBien` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `mail` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `commune` varchar(200) NOT NULL,
  `rue` varchar(50) NOT NULL,
  `cp` int NOT NULL,
  `nbCouchages` int NOT NULL,
  `nbChambres` int NOT NULL,
  `distance` int NOT NULL,
  `prix` int NOT NULL,
  `avis` double NOT NULL,
  PRIMARY KEY (`idBien`),
  KEY `Contact` (`mail`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `biens`
--

INSERT INTO `biens` (`idBien`, `mail`, `commune`, `rue`, `cp`, `nbCouchages`, `nbChambres`, `distance`, `prix`, `avis`) VALUES
('Résidence Lillys', 'julie@email.com', 'Pau', '11 rue du Parlement', 64000, 6, 5, 50, 70, 4.5),
('Résidence Le bon air', 'jules@email.com', 'Pau', '14 rue Louis Barthou', 64000, 4, 3, 100, 50, 4),
('Residence truc much', 'killian@mail.fr', 'Angers', '30 rue de la Martinière', 40000, 6, 4, 200, 240, 2),
('Residence petit', 'killian@mail.fr', 'Angers', '100 avenue des bons', 40000, 2, 1, 300, 70, 2.5),
('Residence de la mer', 'speedy@gmail.com', 'Montpellier', '5 avenue de la fac', 34000, 4, 2, 140, 150, 4),
('Residence des grands', 'speedy@gmail.com', 'Montpellier', '30 avenue des marais', 34000, 8, 3, 1000, 200, 3),
('Residence grands vents', 'speedy@gmail.com', 'Montpellier', '90 rue des malotrus', 34000, 6, 2, 2500, 160, 5);

-- --------------------------------------------------------

--
-- Structure de la table `locations`
--

DROP TABLE IF EXISTS `locations`;
CREATE TABLE IF NOT EXISTS `locations` (
  `idBien` varchar(250) NOT NULL,
  `mailLoueur` varchar(250) NOT NULL,
  `dateDebut` date NOT NULL,
  `dateFin` date NOT NULL,
  `idLocations` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idLocations`),
  KEY `mailLoueur` (`mailLoueur`),
  KEY `idbiens` (`idBien`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `locations`
--

INSERT INTO `locations` (`idBien`, `mailLoueur`, `dateDebut`, `dateFin`, `idLocations`) VALUES
('Résidence Lillys', 'julie@email.com', '2023-12-01', '2023-12-15', 1),
('Résidence Le bon air', 'jules@email.com', '2023-11-23', '2023-12-06', 2),
('Résidence Lillys', 'Utilisateur@mail.fr', '2023-12-22', '2023-12-30', 4),
('Résidence Lillys', 'Utilisateur@mail.fr', '2024-01-18', '2024-01-26', 6),
('Résidence Le bon air', 'Utilisateur@mail.fr', '2024-01-24', '2024-02-01', 9),
('Résidence Lillys', 'Utilisateur@mail.fr', '2024-01-24', '2024-02-01', 10),
('Residence truc much', 'Utilisateur@mail.fr', '2024-01-24', '2024-02-01', 13),
('undefined', 'Utilisateur@mail.fr', '2024-03-15', '2024-03-16', 15);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `mail` varchar(250) NOT NULL,
  `prénom` varchar(50) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `téléphone` int NOT NULL,
  PRIMARY KEY (`mail`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`mail`, `prénom`, `nom`, `téléphone`) VALUES
('julie@email.com', 'Julie', 'Dupont', 645762334),
('jules@email.com', 'Jules', 'Matins', 6780934),
('lily@gmail.com', 'Lily', 'Martin', 654545454),
('speedy@gmail.com', 'speedy', 'gonzales', 733333333),
('Utilisateur@mail.fr', 'Uti', 'lisateur', 123456789);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
