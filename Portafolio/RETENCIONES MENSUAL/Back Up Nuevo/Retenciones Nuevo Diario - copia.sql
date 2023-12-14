	

-- drop table gdc..tbl_retenciones_diario

--alter table gdc..tbl_retenciones_diario
--add Periodo int

--update gdc..tbl_retenciones_diario
--set periodo = 202006
--where periodo is null


select * from gdc..tbl_retenciones_diario where periodo = 202011




    --update gdc..tbl_retenciones_diario
    --set [Categoría de causa DESC NUEVA] = 'TIENE OTRO PRODUCTO ( NO VISANET)'
    --where Periodo = 202007
    --and ruc in ( 20543722309 , 20302218774 )
 


 

	 delete from gdc..tbl_retenciones_diario
	 where periodo = 202011
	


  
   		select ruc , count ( distinct ( codigo_s )  ) as Q_Cod
		from gdc..vw_indicadores_habilitados
		where periodo_s = 202010
		and ComerciosTemporales = 0 
		and SUB_PRODUCTOS <> 'QR'
		-- and Producto = 'pos'
		-- and Producto = 'CE'
		and EstadoHabilitado = 1
		and ruc in (  )
		group by ruc


        select * 
		from gdc..tbl_final_aislado_codigo
		where Periodo = 202010
		and codigo_s in (  )


		select * 
		from V_Segmento_Cliente
		where ruc in (  )

		select *
		from gdc..tbl_grupo_valor_final
		where periodo = 202010
		and ruc in (  )



	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20384891943
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10428231045
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600535472
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602511538
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20114856429
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10077531829
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20100024862
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20100662982
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20101278582
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20102097069
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20104102744
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20120576365
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	17282936151
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20286998594
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20319809334
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20333684021
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20364877987
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20393126974
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20411022413
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20431062870
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20432115284
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20434813124
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20448375952
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20449210736
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20450930939
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20455856206
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20456047727
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20481628351
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20490674293
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20491009650
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20492247619
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20492387623
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	15514228211
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20524189764
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20527604614
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20528063722
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20530711472
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20531963904
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20533237666
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20534329645
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20535802972
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20536222244
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20536445201
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20536780506
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20537552752
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20537661969
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20537941066
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20542392119
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20546938345
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20546941214
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20548539987
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20548569622
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20549309845
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20549400176
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20550237190
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20553805628
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20553821151
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20554412352
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20554755047
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20557730762
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20557779001
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20558138689
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20562649736
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20565604083
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20565765842
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20567179517
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20569126224
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600009975
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600068025
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600080050
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600096606
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600376838
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600388445
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600931521
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601111382
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601216982
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601221072
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601229677
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601266611
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601785031
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602099611
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602268331
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602483721
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602514367
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602519024
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602652301
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602748597
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602796711
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603213883
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603516487
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603577192
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603597924
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603757638
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603858761
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20604375615
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601516021
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20604586501
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10339545982
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20501760961
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603690061
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10297214581
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10193310571
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10061358612
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10067724416
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10417565715
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10296893205
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20604637172
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20487506215
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20555090693
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10453880848
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600070151
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20522251241
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10096417841
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10705558944
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	15604884150
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10092809809
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10295689167
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20452479029
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10200066109
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10100306226
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10438826390
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20543323862
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10428771619
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20506035121
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10103378261
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10096046532
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10743563412
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10476153030
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10415918084
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601932700
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10467244481
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10180411106
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10421618807
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10428877905
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10220723963
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10468402942
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10090423741
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20501704548
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20605791558
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20183034180
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20450633560
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20145906254
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	15605096660
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20386489263
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10431915401
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601089123
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20606138700
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20604960054
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10422844843
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602340962
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10763233940
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20513654619
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107011621
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10400261771
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10100439536
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10101051523
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10101522569
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10002403698
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10402469159
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10102983969
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10403072635
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10703336979
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10403853475
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10404399671
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10404607761
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10405261150
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10106409612
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10406570083
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10406767120
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10106914121
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107185297
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107278201
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107353971
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107360617
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10408083651
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10008205138
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10408897462
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10409296195
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10309412708
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10410167358
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10410241612
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10410463364
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10410894331
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10411260955
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10413849506
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10214049045
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10415362264
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10415932630
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10316568551
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10316808269
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10417359392
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10417818966
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10418733794
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10420546802
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10321352982
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10422484642
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10723056867
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10028204332
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10428783951
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10431050019
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10731719182
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10437710517
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10437748522
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10238488678
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10239636344
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10440894661
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10441032701
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10443580757
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10046364118
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10451180342
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10153705131
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10255635919
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10258049930
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10258379018
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10258435333
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10459143730
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10460152998
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10060161891
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10060308620
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10061016576
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10061712980
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10461869616
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10764125636
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10068005413
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10068099752
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10468650784
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10769407281
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10072593419
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10473452257
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10473912584
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10774386365
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10474687339
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10179904051
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10181671764
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10082571570
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10083016189
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10485588251
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10085913633
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10086464751
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10093332844
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10094055798
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10094684116
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10095759179
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10296906994
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10097025644
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10097030834
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10097856350
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10098003814
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10098216371
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10099879438
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10099924310
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10099947727
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20100039037
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20101869947
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20102032790
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20107945874
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20114767329
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20125413685
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20132373958
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20170040938
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20172425632
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20252947265
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20301409151
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20316978917
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20329790682
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20345161113
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20357023000
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20379074996
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20396466768
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20409270931
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601354129
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20447330211
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20452357420
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20454377878
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20459802437
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20479676276
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20480333005
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20482333762
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20491202816
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20494619173
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20505851316
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20506738807
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20508277637
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20511163481
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20511727520
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20512047352
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20513516143
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20515040201
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20520009982
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20521186543
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20522615201
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20527344019
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20527395276
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20527988412
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20531014708
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20531622660
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20532307768
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20532795118
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20533251227
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20533850449
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20535049816
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20535050237
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20541661507
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20545726034
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20547533063
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20549911189
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20551604145
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20553008795
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20553330093
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20557899759
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20559614689
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20559662063
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20561296422
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20563459493
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20569173907
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20569252955
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600366760
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600448286
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600499042
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600609727
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600622065
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600685644
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600686012
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600769945
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600831641
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601005540
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601088119
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601328781
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601405432
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601667275
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601760381
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601926459
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601977100
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602287166
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602306969
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602648991
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	15603044077
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603258194
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603346760
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603597584
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10470697810
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10450280467
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10704162095
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10458079531
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10469573571
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10418137865
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20601375282
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10080164926
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10096463061
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10408371142
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10775719724
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10442338952
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10453006811
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10448146109
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10735956324
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10431368949
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10102053791
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107838878
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10458254732
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10415019403
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10062269800
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20483807601
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10719335221
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10445447493
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10416204310
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10707947867
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10000759193
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10406094494
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600114957
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10167713748
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10707493122
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10767776638
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20553173991
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20101087647
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10405939768
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20600775376
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20603861648
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10457534871
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10743682519
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10422014557
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20602888372
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10074819201
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	20456150064
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10200706477
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10100877835
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10101075686
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10401244650
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10402406831
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10802482499
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10102735248
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10103201484
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10405229027
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10106107781
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10407119067
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10107180881
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10408117602
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10009600111
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10410361898
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10212548648
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10413914910
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10415855996
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10416070771
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10218634937
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10319446881
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10419665962
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10421524438
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10422217431
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10026823388
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10427704659
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10028549046
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10428959782
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10232706100
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10435706024
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10335917389
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10438126410
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10438555728
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10444108865
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10746577970
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10747081188
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10447613421
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10447649727
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10248119972
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10053750945
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10454577120
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10454677256
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10457270050
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10458670370
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10159578980
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10460275909
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10461387522
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10164503068
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10166141708
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10074375567
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10178846341
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10078886761
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10079567065
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10179809732
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10080992144
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10481782266
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10084388497
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10487529767
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10088292362
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10090556229
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10092571586
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10093149420
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10094980718
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10295288774
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10295881475
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10296327994
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10097720342
	update gdc..tbl_retenciones_diario set desafiliado_totalmente = 'Si' where periodo = 202011 and [ruc único] = 1 and RUC = 	10198351054
