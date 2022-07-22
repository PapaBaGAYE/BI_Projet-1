-- Question 1
DECLARE
  -- curseur
  CURSOR src IS SELECT  *  FROM BNNE ;
  -- Enregistrement
  src_r BNNE%ROWTYPE;
BEGIN
  -- Ouvrir le curseur
  OPEN src;
    -- Parcourir les enregistrements de la source
    LOOP
      FETCH  src  INTO src_r;
      EXIT WHEN src%NOTFOUND;


      IF src_r.CodeProduit NOT IN (SELECT CodeProduit FROM Produit) THEN
        INSERT INTO Produit (CodeProduit) VALUES (
          src_r.CodeProduit ,
        );
      END IF;



    END LOOP;

    CLOSE src;

END;


-- Question 2
DECLARE
  -- curseur
  CURSOR src IS SELECT  *  FROM BNNE ;
  -- Enregistrement
  src_r BNNE%ROWTYPE;
  vente_r Vente%ROWTYPE

BEGIN
  -- Ouvrir le curseur
  OPEN src;
    -- Parcourir les enregistrements de la source
    LOOP
      FETCH  src  INTO src_r;
      EXIT WHEN src%NOTFOUND;

      vente_r.IdProduit = SELECT IdProduit FROM Produit WHERE src_r.CodeProduit = Produit.CodeProduit
      vente_r.IdDate = SELECT IdDate FROM Date WHERE src_r.date = Date.date
      vente_r.IdClient = SELECT IdClient FROM Client WHERE src_r.CodeClient = Client.CodeClient
      vente_r.IdVendeur = SELECT IdVendeur FROM Vendeur WHERE src_r.matricule = Vendeur.matricule

      INSERT INTO Vente VALUES (
           vente_r.IdProduit,
           vente_r.IdDate,
           vente_r.IdClient,
           vente_r.IdVendeur,
           src_r.Quantite,
           src_r.PrixUnitaire
        );

    END LOOP;

    CLOSE src;

END;
