create database immobilier;
use immobilier;

#create agence
create table agence (
    idAgence int not null auto_increment primary key,
    nom varchar(30),
    adresse varchar(80)
);
call ps_ajout_agence;
select*from agence;

#create table logement
create table logement (
    idLogement int not null auto_increment primary key,
    type varchar(50) check( type in ('maison','appartement')),
    ville varchar(10),
    prix float,
    superficie int,
    categorie varchar(10) check( categorie in ('vente','location'))
);
call ps_ajout_logement;
select*from logement;

#create logement_agence
create table logement_agence(
    idLogementAgence int not null auto_increment primary key,
    idAgence int,
    idLogement int,
    frais float,
    foreign key (idAgence) references agence(idAgence),
    foreign key (idLogement) references logement(idLogement)
);
call ps_ajout_logement_agence;
select *from logement_agence;

#create table personne
create table personne(
idPersonne int not null auto_increment primary key,
nom varchar (30),
prenom varchar (30),
email varchar (320) unique
);
call ps_ajout_personne ;
select*from personne;

#create table logement_personne
create table logement_personne(
    idLogementPersonne int not null auto_increment primary key,
    idPersonne int,
    idLogement int,
    foreign key (idPersonne) references personne(idPersonne),
    foreign key (idLogement) references logement(idLogement)
);
call ps_ajout_logement_personne;
select*from logement_personne;

#create table demande
create table demande (
    idDemande int not null auto_increment primary key,
    idPersonne int,
    type varchar(50) ,
    ville varchar(10),
    budget float,
    superficie int,
    categorie varchar(10) check( categorie in ('vente','location')),
    foreign key (idPersonne) references personne(idPersonne)
);

drop table demande;

call ps_ajout_demande1;
select*from demande;

#requetes
#1. Affichez le nom des agences 
select nom from agence;

#2. Affichez le numéro de l’agence « Orpi »
select idAgence from agence where nom='orpi';

#3. Affichez le premier enregistrement de la table logement
select * from logement limit 0,1;

#4. Affichez le nombre de logements (Alias : Nombre de logements)
select count(*) as 'nombre de logements' from logement;

#5 Affichez les logements à vendre à moins de 150 000 € dans l’ordre croissant des prix
select * from logement where prix < 150000 and categorie = 'vente' order by prix;

#6. Affichez le nombre de logements à la location (alias : nombre)
select count(idLogement) as 'nombre' from logement where categorie = 'location';

#7. Affichez les villes différentes recherchées par les personnes demandeuses d'un logement
select distinct ville from demande;

#8. Affichez le nombre de biens à vendre par ville
select ville, count(ville) from demande where categorie='vente' group by ville;

#9. Quelles sont les id des logements destinés à la location ?
select idLogement from logement where categorie = 'location';

#10.Quels sont les id des logements entre 20 et 30m² ?
select idLogement from logement where superficie between  20 and 30;

#11.Quel est le prix vendeur (hors frais) du logement le moins cher à vendre ? (Alias : prix minimum)
select min(prix) as 'prix minimum' from logement where categorie = 'vente';

#12.Dans quelles villes se trouve les maisons à vendre ?
select distinct ville from logement where categorie='vente' and type='maison' ;

#13. L’agence Orpi souhaite diminuer les frais qu’elle applique sur le logement ayant l'id « 3 ». Passer les frais de ce logement de 800 à 730€
update logement_agence 
set frais= 730 
where  idLogement=3 and idAgence=5;
select*from logement_agence ;

#14.Quels sont les logements gérés par l’agence « seloger »
select idLogement from logement_agence where idAgence=( select idAgence from agence where nom = 'seloger' );

#15.Affichez le nombre de propriétaires dans la ville de Paris (Alias : Nombre)
select count(idPersonne) from demande where categorie='vente' and ville='paris';
select*from demande;

# 16 Affichez les informations des trois premières personnes souhaitant acheter un logement
# je n'ai pas compris votre requete Mr CAMARA .

#17 Affichez les prénoms, email des personnes souhaitant accéder à un logement en location sur la ville de Paris
select nom,prenom,email from personne ,demande where personne.idPersonne=demande.idPersonne and demande.ville='paris'and demande.categorie='location';

#18. Si l’ensemble des logements étaient vendus ou loués demain, quel serait le
#bénéfice généré grâce aux frais d’agence et pour chaque agence (Alias : bénéfice,
#classement : par ordre croissant des gains)
select sum(frais) as benefice, nom from logement_agence ,agence where logement_agence.idAgence=agence.idAgence 
group by agence.idAgence order by benefice;

#19.Affichez le prénom et la ville où se trouve le logement de chaque propriétaire
select distinct prenom,ville from personne,demande,logement_personne  
where personne.idPersonne=logement_personne.idPersonne and  personne.idPersonne=demande.idPersonne
 and demande.categorie='vente';
 
 #20.Affichez le nombre de logements à la vente dans la ville de recherche de « prenom13 »
 SELECT count(idLogement) as 'nombre'
FROM personne , demande , logement 
WHERE personne.idPersonne = demande.idPersonne 
AND demande.ville = logement.ville 
AND personne.prenom='prenom13'
AND logement.categorie='vente';


#Exercice 4 : Les priviléges 
#Créer deux utilisateurs ‘afpa’ et ‘cda314’
create user 'afpa@localhost' identified by 'test';
create user 'cda314@localhost' identified by 'test_test';
select current_user() from mysql.user;

#Donner les droits d’afficher et d’ajouter des personnes et logements pour l’utilisateur 
grant all *.*  to 'afpa@localhost';

# tout à l'heure la creation avait marché et là elle ne marche plus , on verra à la correction je pense

 












