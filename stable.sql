/*
  ATRIBUTO  6195 - Certificado de qualidade
  COMANDO   1757
*/
 
DECLARE
 
    v_empresa        NUMBER := :p_1;
    v_produto        estitem.codigo%TYPE := :p_2;
    v_versao         pcpversao.versao%TYPE := :p_3;
    v_retorno        VARCHAR2(10);
    v_material       VARCHAR2(100);
    v_cliente_matriz NUMBER;
    v_cliente        NUMBER;
    v_laminado       NUMBER;
    v_picote         NUMBER;
    v_checklist      VARCHAR2(50);
    v_espessura      NUMBER;
    v_representante  NUMBER;
    v_familia        VARCHAR2(200);
    v_classe_produto VARCHAR2(50);
    v_classe         NUMBER;
    v_unidade        VARCHAR2(5);
    v_etapa          NUMBER;
    
BEGIN

    -- Correntista      
    SELECT Max(estitemcorr.correntista)
    INTO   v_cliente
    FROM   estitemcorr
    WHERE  empresa = v_empresa
           AND item = v_produto;

    -- Unidade do Item
    SELECT Nvl(Max(estitem.unidade), '0')
    INTO   v_unidade
    FROM   estitem
    WHERE  estitem.empresa = v_empresa
           AND estitem.codigo = v_produto;

    -- Familia Produto
    SELECT Nvl(Max(estfamilia.descricao), '0')
    INTO   v_familia
    FROM   estitem,
           estfamilia
    WHERE  estitem.empresa = estfamilia.empresa
           AND estitem.familia = estfamilia.codigo
           AND estitem.empresa = v_empresa
           AND estitem.codigo = v_produto;

    -- Classe Produto         
    SELECT Nvl(Max(estclasse.descricao), '0'),
           Nvl(Max(estclasse.codigo), 0)
    INTO   v_classe_produto, v_classe
    FROM   estitem,
           estclasse
    WHERE  estitem.empresa = estclasse.empresa
           AND estitem.classe_produto = estclasse.codigo
           AND estitem.empresa = v_empresa
           AND estitem.codigo = v_produto;

    -- Matriz do Cliente      
    SELECT codigo_matriz
    INTO   v_cliente_matriz
    FROM   cadcorr
    WHERE  codigo = v_cliente;

    -- Representante        
    SELECT Nvl(Max(vendedor), 0)
    INTO   v_representante
    FROM   cadrepcli
    WHERE  empresa = 1
           AND cliente = v_cliente;

    -- Atributo Material Ficha Técnica
    SELECT Max(valor_padrao)
    INTO   v_material
    FROM   pcpficha
    WHERE  empresa = v_empresa
           AND produto = v_produto
           AND versao = v_versao
           AND atributo = 1;

    SELECT Nvl(Max(valor_padrao), '0')
    INTO   v_checklist
    FROM   pcpficha
    WHERE  empresa = v_empresa
           AND produto = v_produto
           AND versao = v_versao
           AND atributo = 6405;

    -- Atributo Espessura Ficha Técnica
    SELECT Replace(Max(valor_padrao), '.', ',')
    INTO   v_espessura
    FROM   pcpficha
    WHERE  empresa = v_empresa
           AND produto = v_produto
           AND versao = v_versao
           AND atributo = 22;

    -- Verificar se item é laminado          
    SELECT Count(*)
    INTO   v_laminado
    FROM   pcpversao,
           pcpetaparoteiro
    WHERE  pcpversao.empresa = pcpetaparoteiro.empresa
           AND pcpversao.roteiro = pcpetaparoteiro.roteiro
           AND pcpversao.empresa = v_empresa
           AND pcpversao.produto = v_produto
           AND pcpversao.versao = v_versao
           AND pcpetaparoteiro.etapa BETWEEN 30 AND 39;

    -- Buscar etapa Refiladeira / Corte Solda
    SELECT Max(pcpetaparoteiro.etapa)
    INTO   v_etapa
    FROM   pcpversao,
           pcpetaparoteiro
    WHERE  pcpversao.empresa = pcpetaparoteiro.empresa
           AND pcpversao.roteiro = pcpetaparoteiro.roteiro
           AND pcpversao.empresa = v_empresa
           AND pcpversao.produto = v_produto
           AND pcpversao.versao = v_versao
           AND pcpetaparoteiro.etapa BETWEEN 40 AND 59;

    -- Extrusao Picote
    SELECT Nvl(Max(pcpetaparoteiro.etapa), 0)
    INTO   v_picote
    FROM   pcpversao,
           pcpetaparoteiro
    WHERE  pcpversao.empresa = pcpetaparoteiro.empresa
           AND pcpversao.roteiro = pcpetaparoteiro.roteiro
           AND pcpversao.empresa = v_empresa
           AND pcpversao.produto = v_produto
           AND pcpversao.versao = v_versao
           AND pcpetaparoteiro.etapa = 11;

    IF v_etapa >= 50 THEN -- Corte & Solda
      CASE
        WHEN ( v_cliente = 3480 ) THEN
          v_retorno := '9';
        WHEN v_cliente_matriz = 6469
             AND v_classe IN ( 24, 25 ) THEN
          v_retorno := '88';
        WHEN v_cliente_matriz = 6469
             AND v_unidade = 'MIL'
             AND v_material LIKE '%PA%' THEN
          v_retorno := '90';
        WHEN v_cliente_matriz = 6469
             AND v_unidade = 'MIL'
             AND v_material LIKE '%PE%'
             AND v_material NOT LIKE '%+%'
             AND v_material NOT LIKE '%LAM%'
             AND v_material NOT LIKE '%PA%' THEN
          v_retorno := '86';
        WHEN v_cliente_matriz = 6469
             AND v_unidade = 'MIL'
             AND v_material LIKE '%+%'
             AND v_laminado > 0 THEN
          v_retorno := '87';
        WHEN ( v_cliente_matriz = 2866 ) THEN
          v_retorno := '10';
        WHEN ( v_cliente_matriz = 8609 ) THEN
          v_retorno := '11';
        WHEN ( v_cliente_matriz = 2523 ) THEN
          v_retorno := '12';
        WHEN ( v_cliente_matriz = 2847 ) THEN
          v_retorno := '13';
        WHEN ( v_cliente_matriz = 8141 ) THEN
          v_retorno := '14';
        WHEN ( v_cliente_matriz = 196 ) THEN
          v_retorno := '15';
        WHEN ( v_cliente_matriz = 133 ) THEN
          v_retorno := '16';
        WHEN ( v_cliente_matriz = 1910 ) THEN
          v_retorno := '17';
        WHEN ( v_cliente_matriz = 2423 ) THEN
          v_retorno := '18';
        WHEN ( v_cliente_matriz = 6171 ) THEN
          v_retorno := '19';
        WHEN ( v_cliente_matriz = 2437 ) THEN
          v_retorno := '20';
        WHEN ( v_cliente_matriz = 8142 ) THEN
          v_retorno := '21';
        WHEN ( v_cliente_matriz = 6157 ) THEN
          v_retorno := '22';
        WHEN ( v_cliente_matriz = 3459 ) THEN
          v_retorno := '23';
        WHEN ( v_cliente_matriz = 6256 ) THEN
          v_retorno := '24';
        WHEN ( v_cliente_matriz = 8063 ) THEN
          v_retorno := '25';
        WHEN ( v_cliente_matriz = 3694 ) THEN
          v_retorno := '26';
        WHEN ( v_cliente_matriz = 3456 ) THEN
          v_retorno := '27';
        WHEN ( v_cliente_matriz = 2998 ) THEN
          v_retorno := '28'; -- matsuda
        WHEN ( v_cliente_matriz = 9630 ) THEN
          v_retorno := '28'; -- matsuda
        WHEN ( v_cliente_matriz = 8262 ) THEN
          v_retorno := '29';
        WHEN ( v_cliente_matriz = 7920 ) THEN
          v_retorno := '30';
        WHEN ( v_cliente_matriz = 3176 ) THEN
          v_retorno := '32';
        WHEN ( v_cliente_matriz = 6604 ) THEN
          v_retorno := '33';
        WHEN ( v_cliente_matriz = 3221 ) THEN
          v_retorno := '34';
        WHEN ( v_cliente_matriz = 7917 ) THEN
          v_retorno := '35';
        WHEN ( v_cliente_matriz = 7684 ) THEN
          v_retorno := '36'; --ritter 
        WHEN ( v_cliente_matriz = 3476 ) THEN
          v_retorno := '37'; -- florestal
        WHEN ( v_cliente_matriz = 3747 ) THEN
          v_retorno := '38';
        WHEN ( v_cliente_matriz = 9109 ) THEN
          v_retorno := '39'; --dauper
        WHEN ( v_cliente_matriz = 7322 ) THEN -- mezzani
          CASE
            WHEN v_produto IN ( '732212', '732213' ) THEN
              v_retorno := '40'; --  732212 / 732213 
            WHEN v_produto IN ( '732210', '732211' ) THEN
              v_retorno := '44'; --  732210 / 732211 
            ELSE
              v_retorno := '8'; -- padrao do corte e solda
          END CASE;
        WHEN ( v_cliente_matriz = 8491 ) THEN
          v_retorno := '41'; -- jbs
        WHEN ( v_cliente_matriz = 9320 ) THEN
          v_retorno := '41'; -- jbs
        WHEN ( v_cliente_matriz = 10034 ) THEN
          v_retorno := '41'; -- jbs
        WHEN ( v_cliente_matriz = 2432 ) THEN
          v_retorno := '42'; --aurora
        WHEN ( v_cliente_matriz = 2448 ) THEN
          v_retorno := '42'; --aurora
        WHEN ( v_cliente_matriz = 3399 ) THEN
          v_retorno := '43'; --ireks
        WHEN ( v_cliente_matriz = 9988 ) THEN
          v_retorno := '80'; -- bimbo
        WHEN ( v_cliente_matriz = 10031 ) THEN
          v_retorno := '80'; -- bimbo
        WHEN ( v_cliente_matriz = 10033 ) THEN
          v_retorno := '80'; -- bimbo
        WHEN ( v_cliente_matriz = 10032 ) THEN
          v_retorno := '80'; -- bimbo
        WHEN ( v_cliente_matriz = 10117 ) THEN
          v_retorno := '80'; -- bimbo
        WHEN ( v_cliente_matriz = 7185 ) THEN
          v_retorno := '81'; --brf mareu
          
        WHEN ( v_cliente_matriz = 177 ) THEN
          v_retorno := '100'; -- CAPRICHO
          
        ELSE
          v_retorno := '8'; -- padrao do corte e solda
          
      END CASE;
      
    -- dbms_output.put_line ('ficha corte e solda: ' || v_retorno );
    -- 7 - padrao refiladeira     
    
    ELSE
      IF v_etapa < 50 AND v_picote <> 11 THEN --- refiladeira
        CASE
          WHEN ( v_cliente_matriz = 3480 ) THEN
            v_retorno := '45'; -- nutrire
          WHEN v_cliente_matriz = 6469
               AND v_classe IN ( 24, 25 ) THEN
            v_retorno := '88';
          WHEN ( v_cliente_matriz = 2866 ) THEN
            v_retorno := '46'; -- lar
          WHEN ( v_cliente_matriz = 8609 ) THEN
            v_retorno := '47'; -- granja pineiros
          WHEN ( v_cliente_matriz = 2523 ) THEN
            v_retorno := '48'; -- nutrifrango
          WHEN ( v_cliente_matriz = 2847 ) THEN
            v_retorno := '49'; -- copacol
          WHEN ( v_cliente_matriz = 8141 ) THEN
            v_retorno := '50';
          WHEN ( v_cliente_matriz = 196 ) THEN
            v_retorno := '51';
          WHEN ( v_cliente_matriz = 133 ) THEN
            v_retorno := '52';
          WHEN ( v_cliente_matriz = 1910 ) THEN
            v_retorno := '53';
          WHEN ( v_cliente_matriz = 2423 ) THEN
            v_retorno := '54';
          WHEN ( v_cliente_matriz = 6171 ) THEN
            v_retorno := '55';
          WHEN ( v_cliente_matriz = 2437 ) THEN
            v_retorno := '56';
          WHEN ( v_cliente_matriz = 8142 ) THEN
            v_retorno := '57';
          WHEN ( v_cliente_matriz = 6157 ) THEN
            v_retorno := '58';
          WHEN ( v_cliente_matriz = 3459 ) THEN
            v_retorno := '59';
          WHEN ( v_cliente_matriz = 6256 ) THEN
            v_retorno := '60';
          WHEN ( v_cliente_matriz = 8063 ) THEN
            v_retorno := '61';
          WHEN ( v_cliente_matriz = 3694 ) THEN
            v_retorno := '62';
          WHEN ( v_cliente_matriz = 3456 ) THEN
            v_retorno := '63';
          WHEN ( v_cliente_matriz = 2998 ) THEN
            v_retorno := '64'; -- matsuda
          WHEN ( v_cliente_matriz = 9630 ) THEN
            v_retorno := '64'; -- matsuda
          WHEN ( v_cliente_matriz = 8262 ) THEN
            v_retorno := '65';
          WHEN ( v_cliente_matriz = 7920 ) THEN
            v_retorno := '66';
          WHEN ( v_cliente_matriz = 9032 ) THEN
            v_retorno := '66';
          WHEN ( v_cliente_matriz = 3176 ) THEN
            v_retorno := '68';
          WHEN ( v_cliente_matriz = 6604 ) THEN
            v_retorno := '69';
          WHEN ( v_cliente_matriz = 3221 ) THEN
            v_retorno := '70'; --ninfa
          WHEN ( v_cliente_matriz = 7917 ) THEN
            v_retorno := '71';
          WHEN ( v_cliente_matriz = 7684 ) THEN
            v_retorno := '72'; --ritter
          WHEN ( v_cliente_matriz = 3476 ) THEN
            v_retorno := '73'; --florestal
          WHEN ( v_cliente_matriz = 3747 ) THEN
            v_retorno := '74'; -- germani
          WHEN ( v_cliente_matriz = 9109 ) THEN
            v_retorno := '75';
          WHEN ( v_cliente_matriz = 7322 ) THEN
            v_retorno := '76'; -- mezzani 
          WHEN ( v_cliente_matriz = 8491 ) THEN
            v_retorno := '77'; -- jbs
          WHEN ( v_cliente_matriz = 10034 ) THEN
            v_retorno := '77'; -- jbs
          WHEN ( v_cliente_matriz = 9320 ) THEN
            v_retorno := '77'; -- jbs
          WHEN ( v_cliente_matriz = 2432 ) THEN
            v_retorno := '78'; -- aurora
          WHEN ( v_cliente_matriz = 2448 ) THEN
            v_retorno := '78'; -- aurora
          WHEN ( v_cliente_matriz = 3399 ) THEN
            v_retorno := '79';
          WHEN ( v_cliente_matriz = 11275 ) THEN
            v_retorno := '93';
          WHEN ( v_cliente_matriz = 10478 ) THEN
            v_retorno := '101'; --Sao Luiz
          --Cliente Arcor              
          WHEN v_cliente_matriz = 10553 AND v_checklist = 'OK' THEN
            v_retorno := '98';
          WHEN v_cliente_matriz = 10553 AND v_material = 'BOPP + PE' THEN
            v_retorno := '83';
          WHEN v_cliente_matriz = 10553 AND v_material = 'PP + PE' THEN
            v_retorno := '95';
          WHEN v_cliente_matriz = 10553 AND v_material = '1 - PE' THEN
            v_retorno := '96';
          WHEN v_cliente_matriz = 10553 AND v_material = 'BOPP PLANO + BOPP' THEN
            v_retorno := '97';
          WHEN ( v_cliente_matriz = 10999 AND v_produto = '109990' ) THEN
            v_retorno := '85'; --fugini
          WHEN ( v_cliente_matriz = 3747 AND v_produto = '374710' ) THEN
            v_retorno := '74'; --germani
          WHEN ( v_cliente_matriz = 3747 AND v_produto = '374709' ) THEN
            v_retorno := '74'; --germani
          WHEN ( v_cliente_matriz = 6112 AND v_produto = '374710' ) THEN
            v_retorno := '74'; --germani
          WHEN ( v_cliente_matriz = 6112 AND v_produto = '374709' ) THEN
            v_retorno := '74'; --germani
          WHEN ( v_cliente_matriz = 6469 AND v_produto = '647684' ) THEN
            v_retorno := '90'; --BRF MARAU
          WHEN ( v_cliente_matriz = 6469 AND v_produto = '536281' ) THEN
            v_retorno := '90'; --BRF MARAU
          WHEN ( v_cliente_matriz = 6469 AND v_produto = '536284' ) THEN
            v_retorno := '90'; --BRF MARAU
            
          WHEN ( v_cliente_matriz = 177 ) THEN
            v_retorno := '100'; -- CAPRICHO
            
          ELSE -- padrao refiladeira
            v_retorno := '7';

        END CASE;
        
      ELSE
        IF v_picote = 11 THEN --- picote extrusao
          CASE
            WHEN ( v_cliente_matriz = 8491 ) THEN
              v_retorno := '1'; -- jbs picotado
            WHEN ( v_cliente_matriz = 1982 ) THEN
              v_retorno := '1'; -- cvale picotado
            WHEN ( v_cliente_matriz = 6469 ) THEN
              v_retorno := '1'; -- cvale picotado
            ELSE
              v_retorno := '2';
          END CASE;
          
        -- dbms_output.put_line ('ficha refiladeira: ' || v_retorno );
        
        END IF;
      END IF;
    END IF;

    --dbms_output.put_line ('produto: ' || v_produto ||' versao: ' || v_versao || ' retorno:' || v_retorno || ' cliente:' || v_cliente_matriz);
    
    UPDATE pcpversao
    SET    pcpversao.certificado = v_retorno
    WHERE  empresa = v_empresa
           AND produto = v_produto
           AND versao = v_versao;

    COMMIT;

    :p_4 := v_retorno;
    
END;
