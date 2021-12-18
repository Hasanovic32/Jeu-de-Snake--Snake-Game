#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrÃ©e clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrÃ©es clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de maniÃ¨re linÃ©aire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz oÃ¹
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadÃ©cimal
#   00 <= yy <= ff est la couleur verte en hexadÃ©cimal
#   00 <= zz <= ff est la couleur bleue en hexadÃ©cimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff, 0x00ffffff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16
.eqv white 20

# DerniÃ¨re position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# ParamÃ¨tres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: RÃ©initialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la derniÃ¨re position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 16
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $s3 12($sp)

lw $s0 tailleSnake
sll $s0 $s0 2 #décale de 2 bits vers la gauche ~ faire * 4 
li $s1 0
li $t5 24		#nombre de couleurs *4

#changer la couleur du serpent
lw $a0 Rainbow_snake
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4		#compteur tableau de couleur
li $s2 4		#compteur taille serpent

#la couleur change à chaque itération (tableau qui boucle)
PSLoop:
bge $s2 $s0 endPSLoop

lw $a0 Rainbow_snake($s1)
lw $a1 snakePosX($s2)
lw $a2 snakePosY($s2)
jal printColorAtPosition
addi $s2 $s2 4
beq $s1 $t5 resetColor 
addu $s1 $s1 4
j PSLoop
resetColor:
li $s1 0
j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $s2 12($sp)
addu $sp $sp 16
jr $ra

################################ printObstacles ################################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage Ã  l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalitÃ© des Ã©lÃ©ments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# ParamÃ¨tres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position alÃ©atoire sur un emplacement non utilisÃ©
#              qui ne se trouve pas devant le serpent.
# ParamÃ¨tres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# ParamÃ¨tres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 
#			2 (bas), 3 (gauche), 		
#			4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# ParamÃ¨tres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# ParamÃ¨tres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
lw $a0 milli
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# Ã€ vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tÃªte du serpent se trouve Ã  (snakePosX[0], snakePosY[0]) et la queue Ã 
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # CoordonnÃ©es X du serpent ordonnÃ© de la tÃªte Ã  la queue.
snakePosY:     .word 0 : 1024  # CoordonnÃ©es Y du serpent ordonnÃ© de la t.

# Les directions sont reprÃ©sentÃ©s sous forme d'entier allant de 0 Ã  3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle prÃ©sent dans le jeu.
obstaclesPosX: .word 0 : 1024  # CoordonnÃ©es X des obstacles
obstaclesPosY: .word 0 : 1024  # CoordonnÃ©es Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

#####################################Ajout#####################################

phraseFinGame: .asciiz "Ma grand-mère fait mieux\n"
phraseScoreJeu: .asciiz "Score : "

#sleep times (pour le bonus)
milli: .word 700 

#coordonnées des pixels pour chaque chiffres (pour le bonus)
unX: .word 10, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3
unY: .word 0, 1, 6, 0, 1, 2, 3, 4, 5, 6, 6

deuxX: .word 14, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4
deuxY: .word 0, 1, 6, 0, 5, 6, 0, 4, 6, 0, 3, 6, 1, 2, 6

troisX: .word 14, 0, 0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4
troisY: .word 0, 0, 5, 0, 6, 0, 2, 6, 0, 1, 3, 6, 0, 4, 5

quatreX: .word 14, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4
quatreY: .word 0, 3, 4, 2, 4, 1, 4, 0, 1, 2, 3, 4, 5, 6, 4

cinqX: .word 16, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4
cinqY: .word 0, 0, 1, 2, 5, 0, 3, 6, 0, 3, 6, 0, 3, 6, 0, 4, 5 

sixX: .word 16, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4
sixY: .word 0, 1, 2, 3, 4, 5, 0, 3, 6, 0, 3, 6, 0, 3, 6, 4, 5

septX: .word 11, 0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4
septY: .word 0, 0, 0, 4, 5, 6, 0, 3, 0, 2, 0, 1

huitX: .word 17, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4
huitY: .word 0, 1, 2, 4, 5, 0, 3, 6, 0, 3, 6, 0, 3, 6, 1, 2, 4, 5

neufX: .word 16, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4
neufY: .word 0, 1, 2, 0, 3, 6, 0, 3, 6, 0, 3, 6, 1, 2, 3, 4, 5 

zeroX: .word 19, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4
zeroY: .word 0, 1, 2, 3, 4, 5, 0, 4, 6, 0, 3, 6, 0, 2, 6, 1, 2, 3, 4, 5

#tableau de couleurs pour le rainbow snake (pour le bonus)
Rainbow_snake: .word 0x0066cc00, 0x0000ccff, 0x003300ff, 0x006600ff , 0x00ff6600, 0x00ffff00, 0x00ff0000
#+couleur white dans l'autre tableau avec:	
#.eqv white 20 et 0x00ffffff

.text

################################# majDirection #################################
# ParamÃ¨tres: $a0 La nouvelle position demandÃ©e par l'utilisateur. La valeur
#                 Ã©tant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent Ã  Ã©tÃ© mise Ã  jour.
# Post-condition: La valeur du serpent reste intacte si une commande illÃ©gale
#                 est demandÃ©e, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente Ã  du cannibalisme
#                 et Ã  Ã©tÃ© proscrit par la loi dans les sociÃ©tÃ©s reptiliennes.
################################################################################

majDirection:
# En haut, ... en bas, ... Ã  gauche, ... Ã  droite, ... ces soirÃ©es lÃ  ...
#prologue

#corps
#switch case snakeDir{0,1,2,3} 
beq $a0 4 endMajDir	#doit être différent de 4(touche illégale) pour pouvoir continuer
lw $t0 snakeDir		#on stocke la direction enregistré dans snakeDir

haut_cond:  		
beq $t0 0 haut_body 	
j droite_cond		
haut_body:		
beq $a0 2 endMajDir 
j changeDir		

droite_cond:
beq $t0 1 droite_body
j bas_cond
droite_body:
beq $a0 3 endMajDir
j changeDir

bas_cond:
beq $t0 2 bas_body
j gauche_cond
bas_body:
beq $a0 0 endMajDir
j changeDir

gauche_cond:
beq $t0 3 gauche_body
j endMajDir 		#en cas d'erreur (aucun case correspond à la valeur)
gauche_body:
beq $a0 1 endMajDir
j changeDir

changeDir:
sw $a0 snakeDir

#epilogue
endMajDir:
jr $ra

############################### updateGameStatus ###############################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: L'Ã©tat du jeu est mis Ã  jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent Ã  manger le bonbon
#                    - Si oui dÃ©placer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:

# jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt
#prologue
#on alloue de la place dans la pile pour des registres temporaires
addi $sp $sp -20
sw $s0 16($sp)
sw $s1 12($sp)
sw $s2 8($sp)
sw $s3 4($sp)
sw $ra 0($sp)

#corps
#on stocke la tête du snake ($t0,$t1)
lw $t0 snakePosX 
lw $t1 snakePosY
#on stocke la position du candy ($t2,$t3)
lw $t2 candy
lw $t3 candy+4

#( ($t0==$t2) && ($t1==$t3) ) -> position de la tete==position du candy
bne $t0 $t2 majPosition
bne $t1 $t3 majPosition


casCandy:	#cas où on mange le candy 
#on décrémente le sleep times pour ajouter de la difficulté
lw $t7 milli
ble $t7 180 non 
subi $t7 $t7 40
non:
sw $t7 milli
#on incrémente la taille
lw $t4 tailleSnake
addi $t4 $t4 1
sw $t4 tailleSnake
#on modifie la position du candy
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy+4
#on rajoute un obstacle
lw $t2 numObstacles	#on stocke le nombre d'élémentts dans $t2
mul $t2 $t2 4  
la $s0 obstaclesPosX	#on stocke l'adresse dur premier élément du tableau obstaclesPosX 
			#dans $s0
add $s0 $s0 $t2		#on ajoute à l'adresse 4*numObstacles pour obtenir l'adresse du prochaine 
			#élément que l'on va ajouter 
la $s1 obstaclesPosY	#de même avec obstaclesPosY  
add $s1 $s1 $t2 
jal newRandomObjectPosition
sw $v0 0($s0)
sw $v1 0($s1) 
#on incrémente le nbre d'obstacles
lw $t5 numObstacles
addi $t5 $t5 1
sw $t5 numObstacles
#on incrémente le score 
lw $t3 scoreJeu
addi $t3 $t3 1
sw $t3 scoreJeu

majPosition:
#chaque éléments prends la position de son prochain sauf la tête où la position 
#est a calculé en fonction de la direction 
#donc on lit les tableaux snakePosX et snakePosY à l'envers 
# &snakePosX/Y+(taille-2)*4 donne l'adresse du dernier éléments corps (tete exclu) 
lw $s0 tailleSnake	#on stocke la taille du snake dans $s0
beq $s0 1 majPosTete	#cas où la taille=1 le calcul de la position de la tête est
			#suffisant car il n'y a pas de corps
la $s1 snakePosX	#on stocke l'adresse dur premier élément du tableau snakePosX 
			#dans $s1
la $s2 snakePosY	#on stocke l'adresse dur premier élément du tableau snakePosX 
			#dans $s2
#on calcule la condition d'arret nécessaire plus bas
sub $t0 $s1 4 #sub $t0 $s3 4 
#on calcule l'adresse du dernier éléments
sub $s0 $s0 2	#taille-2
mul $s0 $s0 4	#(taille-2)*4
add $s1 $s1 $s0 #&snakePosX+(taille-2)*4
add $s2 $s2 $s0 #&snakePosY+(taille-2)*4

#on modifie les valeurs à l'aide d'une boucle while
#condition d'arret: adresse=adresse de la tete
while1: 
beq $t0 $s1 majPosTete	#beq $t0 $s3 majPosTete
#pour sankePosX
lw $t1 0($s1)
sw $t1 4($s1)
sub $s1 $s1 4 
#pour snakePosY
lw $t2 0($s2)
sw $t2 4($s2)
sub $s2 $s2 4
b while1

majPosTete:
#switch case snakeDir{0,1,2,3} comme dans la focntion majDirection
lw $s0 snakeDir		#on stocke la direction dans $s0
lw $s1 snakePosX	#on stocke la position X de la tête dans $s1
lw $s2 snakePosY	#on stocke la position Y de la tête dans $s2

up_cond:
beq $s0 0 up_body
j right_cond
up_body:
addi $s1 $s1 1
sw $s1 snakePosX
j endMajPosition

right_cond:
beq $s0 1 right_body
j down_cond
right_body:
addi $s2 $s2 1
sw $s2 snakePosY
j endMajPosition

down_cond:
beq $s0 2 down_body
j left_cond
down_body:
sub $s1 $s1 1
sw $s1 snakePosX
j endMajPosition

left_cond:
beq $s0 3 left_body
j endMajPosition
left_body:
sub $s2 $s2 1
sw $s2 snakePosY
j endMajPosition

#epilogue
endMajPosition:
#on free la place alloué		
lw $s0 16($sp)
lw $s1 12($sp)
lw $s2 8($sp)
lw $s3 4($sp)
lw $ra 0($sp)
addi $sp $sp 20

jr $ra

############################### conditionFinJeu ################################
# ParamÃ¨tres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################


conditionFinJeu:
# prologue 
#on alloue de la place dans la pile pour des registres temporaires
addi $sp $sp -28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $s3 12($sp)
sw $s4 8($sp)
sw $s5 4($sp)
sw $ra 0($sp)

#corps
li $v0 0		#sécurité 
lw $s0 numObstacles	#on stocke la taille du snake dans $s0
beq $s0 0 test2		#cas où il n'y a pas d'obstacles: cannibalisme impossible et 
			#pas d'obstacles donc seul les limites de la grille posent
			#problème
la $s1 obstaclesPosX	#on stocke l'adresse dur premier élément du tableau snakePosX 
			#dans $s1
la $s2 obstaclesPosY	#on stocke l'adresse dur premier élément du tableau snakePosX 
			#dans $s2
#on calcule notre condtion d'arret necessaire plus bas (test1)
mul $s0 $s0 4		#numObstacles*4
add $s0 $s0 $s1		#&obstaclesPosX+(numObstacles*4)
lw $t4 snakePosX	#on stocke la position X de la tete dans $t4
lw $t5 snakePosY	#on stocke la position Y de la tete dans $t5
li $t0 2		#switch pour passer de test obstacles à test cannibalisme

test1:
test1x:
beq $s1 $s0 pasObstacle #cas où il n'y a pas\plus d'obstacles à tester
lw $s4 0($s1)		#on stocke la position X de l'obstacle dans $s4
beq $t4 $s4 test1y	#Position X tete==Position X obstacle

loop_test1:
addi $s1 $s1 4		
addi $s2 $s2 4
j test1x

test1y:
lw $s5 0($s2)
beq $t5 $s5 perdu	#Position Y tete==Position Y obstacle
j loop_test1

pasObstacle:
sub $t0 $t0 1		#une première fois pour switch et une deuxième fois pour 
			#passer au test2 (limites de la grille)
beq $t0 0 test2		#deuxième fois on passe au test2
#on ne compare plus la position de la tete avec celles des obstacles mais avec celles 
#du corps 
la $t1 snakePosX
addi $s1 $t1 4		#pour parcourir snakePosX
la $t2 snakePosY
addi $s2 $t2 4		#pour parcourir snakePosY
#on calcule notre nouvelle condition d'arret (test1bis)
lw $t3 tailleSnake
mul $t3 $t3 4
add $s0 $t3 $t1
j test1

test2:
#on teste si la tete n'est pas hors des limites de la grille
lw $t0 snakePosX	#on stocke la position X de la tete dans $t0
lw $t1 snakePosY	#on stocke la position Y de la tete dans $t1
lw $t3 tailleGrille	#on stocke la taille de la grille dans $t3
bltz $t0 perdu
bge $t0 $t3 perdu
bltz $t1 perdu
bge $t1 $t3 perdu
j finCDF

perdu:
#on change la valeur de $v0 pour dire au programme que la partie est perdue
li $v0 1

#epilogue
finCDF:
#on free la place alloué
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $s3 12($sp)
lw $s4 8($sp)
lw $s5 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra
############################### affichageFinJeu ################################
# ParamÃ¨tres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : Â«Quelle pitoyable prestation !Â»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
#prologue
#on alloue de la place dans la pile pour des registres temporaires
addi $sp $sp -28
sw $ra 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $s3 12($sp)
sw $s4 8($sp)
sw $s5 4($sp)
sw $s6 0($sp)
#corps
jal resetAffichage
la $a0 phraseFinGame
li $v0 4
syscall
la $a0 phraseScoreJeu
li $v0 4
syscall
lw $a0 scoreJeu
li $v0 1
syscall
#j endAffFinJeu ##########################################################warning effacer quand la fct est fini 

#on fait modulo 2 du scoreJeu 
#$t0 chiffre des unités
#$t1 chiffre des dizaines
lw $t0 scoreJeu
li $t1 0
#modulo de 10 pour séparer chiffre des dizaines et chiffre des unités
while2:
ble $t0 10 endWhile2
addi $t1 $t1 1
subu $t0 $t0 10
j while2
endWhile2:

move $t6 $t0	#on save $t0 dans $t6 car printColorAtPosition modifie la valeur de $t0
li $t3 1	#pour passer des dizaines à unité 
li $t5 0	#compteur boucle
li $s3 2	#décalage en X pour centrer les chiffres
j zero_cond

#switch case{0,1,2,3,4,5,6,7,8,9}
#$t4 nombre de pixels
#$s1 positions X des pixels
#$s2 positions Y des pixels
zero_cond:
beq $t1 0 zero_body
j un_cond
zero_body:
lw $t4 zeroX	
la $s1 zeroX+4 
la $s2 zeroY+4
j while3

un_cond:
beq $t1 1 un_body
j deux_cond
un_body:
lw $t4 unX	
la $s1 unX+4 
la $s2 unY+4
j while3

deux_cond:
beq $t1 2 deux_body
j trois_cond
deux_body:
lw $t4 deuxX	
la $s1 deuxX+4 
la $s2 deuxY+4
j while3

trois_cond:
beq $t1 3 trois_body
j quatre_cond
trois_body:
lw $t4 troisX	
la $s1 troisX+4 
la $s2 troisY+4
j while3

quatre_cond:
beq $t1 4 quatre_body
j cinq_cond
quatre_body:
lw $t4 quatreX	
la $s1 quatreX+4 
la $s2 quatreY+4
j while3

cinq_cond:
beq $t1 5 cinq_body
j six_cond
cinq_body:
lw $t4 cinqX	
la $s1 cinqX+4 
la $s2 cinqY+4
j while3

six_cond:
beq $t1 6 six_body
j sept_cond
six_body:
lw $t4 sixX	
la $s1 sixX+4 
la $s2 sixY+4
j while3

sept_cond:
beq $t1 7 sept_body
j huit_cond
sept_body:
lw $t4 septX	
la $s1 septX+4 
la $s2 septY+4
j while3

huit_cond:
beq $t1 8 huit_body
j neuf_cond
huit_body:
lw $t4 huitX	
la $s1 huitX+4 
la $s2 huitY+4
j while3

neuf_cond:
beq $t1 9 neuf_body
j endAffFinJeu
neuf_body:
lw $t4 neufX	
la $s1 neufX+4 
la $s2 neufY+4
j while3

#boucle qui affiche un chiffre
while3:
beq $t4 $t5 switch
lw $a1 0($s2)
addi $a1 $a1 4
lw $a2 0($s1)
add $a2 $a2 $s3
lw $a0 colors + white
jal printColorAtPosition
addi $s1 $s1 4
addi $s2 $s2 4
addi $t5 $t5 1
j while3

#refait la même boucle pour le chiffre des unités 
switch:
beq $t3 0 endAffFinJeu
li $s3 9 		#décalage du chiffre à 9
li $t5 0		#compteur boucle remis à 0
sub $t3 $t3 1		#switch à 0
move $t1 $t6		#on mets le chiffre des unités dans $t1
j zero_cond		#on refait la boucle

#epilogue
endAffFinJeu:
#on free la place alloué
lw $ra 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $s3 12($sp)
lw $s4 8($sp)
lw $s5 4($sp)
lw $s6 0($sp)
addi $sp $sp 28
jr $ra
# Fin.
