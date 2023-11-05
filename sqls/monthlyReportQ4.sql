-- 202310
-- 2023-10-31
-----------------------------------------------------!!!通报!!!-----------------------------------------------------------------
/*
 --A20
 SELECT 
 PS.AREA_NAME
 ,P1.JTWY_CNT
 ,P1.ARPU 
 FROM CSROP.COP_R_ASSET_MON_Z P1
 LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS
 ON P1.AREA_ID = PS.AREA_ID
 WHERE P1.BIL_MONTH = '202310' 
 AND P1.ID_TYPE_FLG = '总体' 
 AND P1.STAR_FLG = '总体'
 AND P1.AREA_ID IN ('1','2','3','4','5','9','32518','7','12','10','8','11')
 ORDER BY CASE WHEN P1.AREA_ID = 1 THEN 1 ELSE CAST(PS.ORDER_ID AS INT) END
 ;
 --A20  月净增
 SELECT 
 P1.BIL_MONTH
 ,PS.AREA_NAME
 ,(P1.JTWY_CNT - P2.JTWY_CNT)/TO_CHAR(LAST_DAY(TO_DATE( '202310','YYYYMM')),'DD') JTWY_SXJZ_CNT --5G机套网用一体化时序日均净增
 ,CASE WHEN COALESCE(PP1.VALUE_NBR,0) = 0 THEN 0 ELSE (P1.JTWY_CNT - P2.JTWY_CNT)/TO_CHAR(LAST_DAY(TO_DATE( '202310','YYYYMM')),'DD')/COALESCE(PP1.VALUE_NBR,0) END JTWY_SXJZ_LV
 FROM CSROP.COP_R_ASSET_MON_Z P1
 LEFT JOIN CSROP.COP_R_ASSET_MON_Z P2
 ON P1.AREA_ID = P2.AREA_ID 
 AND P2.ID_TYPE_FLG = '总体' 
 AND P2.STAR_FLG = '总体' 
 AND P2.BIL_MONTH = TO_CHAR(ADD_MONTHS(TO_DATE('202310','YYYYMM'),-1),'YYYYMM') --上月
 LEFT JOIN CSROP.HEMS_A_MKT_2020_FIN_AMT_MB_Z PP1
 ON P1.AREA_ID = PP1.AREA_ID AND PP1.ZBX_FLG = '5G一体化日均' 
 LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS
 ON P1.AREA_ID = PS.AREA_ID
 WHERE P1.BIL_MONTH = '202310' AND P1.ID_TYPE_FLG = '总体' AND  P1.STAR_FLG = '总体'
 AND P1.AREA_ID IN ('1','2','3','4','5','9','32518','7','12','10','8','11')
 ORDER BY CASE WHEN P1.AREA_ID = 1 THEN 1 ELSE CAST(PS.ORDER_ID AS INT) END
 ;
 */
------------------------------------------------1.小合约实收ARPU----------------------------------------------------------
SELECT
  PS.AREA_NAME,
  P1.MON_ARPU 小合约ARPU,
  P1.BIL_MONTH,
  P2.MON_ARPU 星级小合约ARPU
FROM
  CSROP.COP_R_SMALL_CONTRACT_MON_Z P1 --小合约价值变化月报
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
  LEFT JOIN CSROP.COP_R_SMALL_CONTRACT_MON_Z P2 ON P1.AREA_ID = P2.AREA_ID
  AND P2.CHANNEL_FLG = '总体'
  AND P2.ID_TYPE_FLG = '个人证件'
  AND P2.STAR_FLG = '4-7星'
  AND P2.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
WHERE
  P1.CHANNEL_FLG = '总体'
  AND P1.ID_TYPE_FLG = '总体'
  AND P1.STAR_FLG = '总体'
  AND P1.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

------------------------------------------------2.存量重耕季度计算----------------------------------------------------------
--日报 月累计字段
SELECT
  DATE('2023-10-31') DATE_CD,
  P1.AREA_ID,
  CL_MON_CNT / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') CLCG_CNT --存量重耕
,
CASE
    WHEN COALESCE(PPS.VALUE_NBR, 0) = 0 THEN 0
    ELSE CL_MON_CNT / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') / COALESCE(PPS.VALUE_NBR, 0)
  END CLCG_LV
FROM
  CSROP.COP_R_CL_CULTIVATE_DAY_Z P1 --存量重耕日报
  LEFT JOIN CSROP.HEMS_A_MKT_2020_FIN_AMT_MB_Z PPS ON P1.AREA_ID = PPS.AREA_ID
  AND PPS.ZBX_FLG = '存量重耕'
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z PS ON P1.AREA_ID = PS.AREA_ID
WHERE
  P1.DATE_CD = DATE('2023-10-31')
  AND P1.CORP_USER_NAME = '总体'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  PS.AREA_LVL,
  CAST(PS.ORDER_ID AS INT);

------------------------------------------------3.存量重耕实收ARPU----------------------------------------------------------
/*
 --取T-2月报的量
 SELECT   PS.AREA_NAME
 ,P1.CL_30UP_CNT/TO_CHAR(ADD_MONTHS(TO_DATE('202310','YYYYMM'),-1),'YYYYMM') CLCG_CNT
 ,P1.BIL_MONTH
 FROM CSROP.COP_R_CL_CULTIVATE_MON_Z 		 P1 --存量重耕价值变化月报
 LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS
 ON P1.AREA_ID = PS.AREA_ID
 WHERE P1.CHANNEL_DEPT_NAME_2014 = '总体' 
 AND P1.ZDHY_FLG = '总体' 
 AND P1.BIL_MONTH = TO_CHAR(ADD_MONTHS(TO_DATE('202310','YYYYMM'),-1),'YYYYMM') --T-2
 AND P1.AREA_ID IN ('1','2','3','4','5','9','32518','7','12','10','8','11')
 ORDER BY CASE WHEN P1.AREA_ID = 1 THEN 1 ELSE CAST(PS.ORDER_ID AS INT) END
 ;
 
 --测试表
 SELECT   PS.AREA_NAME
 ,P1.YLJ_CL_ARPU
 ,P1.BIL_MONTH			
 FROM CSRTEST.COP_R_CL_CULTIVATE_MON_Z2 		P1 --存量重耕价值变化月报
 LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z 	PS
 ON P1.AREA_ID = PS.AREA_ID
 WHERE P1.CHANNEL_DEPT_NAME_2014 = '总体' 
 AND P1.ZDHY_FLG = '总体' 
 AND P1.BIL_MONTH = TO_CHAR(ADD_MONTHS(TO_DATE('202310','YYYYMM'),-1),'YYYYMM') --T-2
 AND P1.AREA_ID  IN ('1','2','3','4','5','9','32518','7','12','10','8','11')
 ORDER BY CASE WHEN P1.AREA_ID = 1 THEN 1 ELSE CAST(PS.ORDER_ID AS INT) END
 ;
 */
SELECT
  PS.AREA_NAME,
  P1.STEP_YLJ_CL_ARPU,
  P1.BIL_MONTH,
  P1.GTTZ_ARPU
FROM
  CSROP.COP_R_CL_CULTIVATE_MON_Z P1 --存量重耕价值变化月报
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
WHERE
  P1.CHANNEL_DEPT_NAME_2014 = '总体'
  AND P1.ZDHY_FLG = '总体'
  AND P1.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

---------------------------------------------------4.4升5实收ARPU----------------------------------------------------------
SELECT
  P2.AREA_NAME 地市,
  P1.CL_ARPU 存量总体ARPU -- ,P1.GTLX_ARPU    改套拉新ARPU
  -- ,P1.GTWLX_ARPU   改套未拉新ARPU
  -- ,P1.JBLX_ARPU    加包拉新ARPU
  -- ,P1.JBWLX_ARPU   加包未拉新ARPU
,
  P1.BIL_MONTH
FROM
  CSROP.HEMS_R_4UP5G_VALUE_MON_Z P1 --4升5价值变化月报
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
  AND P1.CORP_USER_NAME = '总体'
  AND P2.AREA_LVL IN ('2', '3')
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

---------------------------------------------------5.宽带离网率及日均-----------------------------------------------------
--宽带离网
SELECT
  P7.BIL_MONTH,
  P2.AREA_NAME,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.BRD_LOST_202001 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '02' THEN P7.BRD_LOST_202002 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '03' THEN P7.BRD_LOST_202003 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '04' THEN P7.BRD_LOST_202004 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '05' THEN P7.BRD_LOST_202005 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '06' THEN P7.BRD_LOST_202006 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '07' THEN P7.BRD_LOST_202007 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '08' THEN P7.BRD_LOST_202008 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '09' THEN P7.BRD_LOST_202009 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '10' THEN P7.BRD_LOST_202010 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '11' THEN P7.BRD_LOST_202011 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    WHEN RIGHT('202310', 2) = '12' THEN P7.BRD_LOST_202012 * 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD')
    ELSE 0
  END 宽带离网数,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.LJ_BRD_LOST_LV_202001
    WHEN RIGHT('202310', 2) = '02' THEN P7.LJ_BRD_LOST_LV_202002
    WHEN RIGHT('202310', 2) = '03' THEN P7.LJ_BRD_LOST_LV_202003
    WHEN RIGHT('202310', 2) = '04' THEN P7.LJ_BRD_LOST_LV_202004
    WHEN RIGHT('202310', 2) = '05' THEN P7.LJ_BRD_LOST_LV_202005
    WHEN RIGHT('202310', 2) = '06' THEN P7.LJ_BRD_LOST_LV_202006
    WHEN RIGHT('202310', 2) = '07' THEN P7.LJ_BRD_LOST_LV_202007
    WHEN RIGHT('202310', 2) = '08' THEN P7.LJ_BRD_LOST_LV_202008
    WHEN RIGHT('202310', 2) = '09' THEN P7.LJ_BRD_LOST_LV_202009
    WHEN RIGHT('202310', 2) = '10' THEN P7.LJ_BRD_LOST_LV_202010
    WHEN RIGHT('202310', 2) = '11' THEN P7.LJ_BRD_LOST_LV_202011
    WHEN RIGHT('202310', 2) = '12' THEN P7.LJ_BRD_LOST_LV_202012
    ELSE 0
  END 宽带月均离网率,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.MON_BRD_LOST_LV_202001
    WHEN RIGHT('202310', 2) = '02' THEN P7.MON_BRD_LOST_LV_202002
    WHEN RIGHT('202310', 2) = '03' THEN P7.MON_BRD_LOST_LV_202003
    WHEN RIGHT('202310', 2) = '04' THEN P7.MON_BRD_LOST_LV_202004
    WHEN RIGHT('202310', 2) = '05' THEN P7.MON_BRD_LOST_LV_202005
    WHEN RIGHT('202310', 2) = '06' THEN P7.MON_BRD_LOST_LV_202006
    WHEN RIGHT('202310', 2) = '07' THEN P7.MON_BRD_LOST_LV_202007
    WHEN RIGHT('202310', 2) = '08' THEN P7.MON_BRD_LOST_LV_202008
    WHEN RIGHT('202310', 2) = '09' THEN P7.MON_BRD_LOST_LV_202009
    WHEN RIGHT('202310', 2) = '10' THEN P7.MON_BRD_LOST_LV_202010
    WHEN RIGHT('202310', 2) = '11' THEN P7.MON_BRD_LOST_LV_202011
    WHEN RIGHT('202310', 2) = '12' THEN P7.MON_BRD_LOST_LV_202012
    ELSE 0
  END 宽带当月离网率
FROM
  CSROP.HEMS_A_ASSET_LOST_MON_Z P7 --B14
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P7.AREA_ID = P2.AREA_ID
WHERE
  P7.BIL_MONTH = '202310'
  AND P2.AREA_LVL IN ('2', '3')
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

---------------------------------------------------6.高套流失率及日均-----------------------------------------------------
SELECT
  P1.BIL_MONTH,
  P2.AREA_NAME 地市,
  P1.MRJ_OUT_GT_LV 高套月均流失率,
  P1.OUT_GT_RJ 日均流失,
  P1.OUT_GT_LV 高套用户当月流失率
FROM
  CSROP.COP_R_GT_MON_Z P1 --B10
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.BIL_MONTH = '202310'
  AND P2.AREA_LVL IN ('2', '3')
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

---------------------------------------------------7.融合有效绑定率129及以上-----------------------------------------------
--融合有效绑定率129及以上
SELECT
  P1.DATE_CD,
  P2.AREA_NAME 地市,
  ALL_EFF_BD_PROM_LV C网有效绑定率,
  RH_BD_PROM129UP_LV 融合有效绑定率129及以上
FROM
  CSROP.HEMS_R_CDMA_BD_DAY_Z P1 -- C网有效绑定率日报
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.DATE_CD = '2023-10-31'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

--------------------------------------------------------8.客户经营积分----------------------------------------------------
--客户经营积分
SELECT
  P1.BIL_MONTH,
  P2.AREA_NAME 地市,
  ALL_SCORE / 10000 / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 客户经营积分
FROM
  CSROP.COP_R_SCORE_DAY_TB_MON_Z P1
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.DZ_CHANNEL_FLG = '总体'
  AND P1.AREA_LEVEL IN ('2', '3')
  AND P1.BIL_MONTH = '202310'
  AND P1.CCUST_FLG = '存量客户'
  AND P1.CHANNEL_DEPT_NAME_2014 = '总体'
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

--------------------------------------------------------9.高套提值星级----------------------------------------------------
--电子渠道分版块统计表
SELECT
  P1.DATE_CD,
  PS.AREA_NAME -- ,P1.CLCG_STAR_BAG_VALUE
  -- ,P1.BRD_BAG_STAR_BAG_CNT
  -- ,P1.CLCG_STAR_BAG_VALUE+P1.BRD_BAG_STAR_BAG_CNT 高套提值星级服务包
,
  P1.CLCG_STAR_VALUE,
  P1.BRD_BAG_STAR_CNT,
  P1.CLCG_STAR_VALUE + P1.BRD_BAG_STAR_CNT 高套提值星级
FROM
  CSROP.COP_R_DZ_CHANNEL_DAY_Z P1
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
WHERE
  P1.DATE_CD = '2023-10-31'
  AND P1.TIME_TYPE = '当月'
  AND P1.DATA_TYPE = '日均'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

-----------------------------------------------------10.宽带收费月包ARPU--------------------------------------------------
SELECT
  P1.BIL_MONTH,
  PS.AREA_NAME,
  P1.SFYB_ARPU
FROM
  CSROP.COP_R_BRD_MONTHLY_MON_Z P1 --宽带收费月包价值变化月报
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
WHERE
  P1.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

------------------------11.存量融合套餐码号台阶收入环比（万）、存量融合提值增收（万）------------------------------------
SELECT
  P1.BIL_MONTH,
  PS.AREA_NAME,
  P1.HBUP_MHTJSR_AFT_TAX_AMT 存量融合套餐码号台阶收入环比,
  P2.HBUP_MHTJSR_AFT_TAX_AMT 存量融合提值增收
FROM
  CSROP.COP_R_CL_INCREASE_MON_Z P1 --存量收入整体智治-融合套餐提值跟踪表
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
  LEFT JOIN CSROP.COP_R_CL_INCREASE_MON_Z P2 ON P1.AREA_ID = P2.AREA_ID
  AND P2.PRD_FLG = '提值加约'
  AND P2.BIL_MONTH = '202310'
WHERE
  P1.BIL_MONTH = '202310'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
  AND P1.PRD_FLG = '总体'
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

----------------------------------------12.锁定存量客户融合套餐ARPU提升--------------------------------------------------
SELECT
  P1.BIL_MONTH,
  P2.AREA_NAME 地市,
  P1.CLRHTC_CUST_ARPU_CHG 锁定存量客户融合套餐ARPU提升,
  P1.CLRHCL_CUST_LV 锁定存量套餐流失率
FROM
  CSROP.HEMS_A_MKT_JFJB_1_TB_Z P1 --经分简报
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.AREA_LEVEL IN ('2', '3')
  AND P1.MAINTAIN_GROUP = '总体'
  AND P1.IS_SINGLE_CUST = '总体'
  AND P1.BIL_MONTH = '202310'
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

--------------------------------------------------13.宽活移不活压降-------------------------------------------------------
SELECT
  P1.BIL_MONTH,
  P2.AREA_NAME 地市,
  P1.CL_YJ_CNT / 10000 宽活移不活压降,
  P1.CL_YJ_LV 宽活移不活压降完成率
FROM
  CSROP.COP_GR_RH_KHYH_MON_Z P1
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.BIL_MONTH = '202310'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

--------------------------------------------------14.企微新增宽带绑定率-------------------------------------------------------
/*
 SELECT DATE_CD,LATN_NAME
 ,SUM(P1.MSU_XZ_KUANDAI_QWLJ_CNT) 分子
 ,SUM(P1.MSU_XZ_KUANDAI_CNT) 分母
 ,CASE WHEN SUM(P1.MSU_XZ_KUANDAI_CNT) = 0 THEN 0 ELSE SUM(P1.MSU_XZ_KUANDAI_QWLJ_CNT)/SUM(P1.MSU_XZ_KUANDAI_CNT) END 企微新增宽带绑定率
 FROM CSROP.COP_R_QIWEI_FAZHAN_DAY_Z P1 
 WHERE DATE_CD ='2023-10-31'
 AND RENYUAN_TYPE = '合计'
 GROUP BY DATE_CD,LATN_NAME
 ;
 */
CREATE LOCAL TEMPORARY TABLE COP_R_QIWEI_FAZHAN_DAY_Z ON COMMIT PRESERVE ROWS AS(
  SELECT
    DATE_CD,
    LATN_NAME,
    SUM(P1.MSU_XZ_KUANDAI_QWLJ_CNT) 分子,
    SUM(P1.MSU_XZ_KUANDAI_CNT) 分母,
CASE
      WHEN SUM(P1.MSU_XZ_KUANDAI_CNT) = 0 THEN 0
      ELSE SUM(P1.MSU_XZ_KUANDAI_QWLJ_CNT) / SUM(P1.MSU_XZ_KUANDAI_CNT)
    END 企微新增宽带绑定率
  FROM
    CSROP.COP_R_QIWEI_FAZHAN_DAY_Z P1
  WHERE
    DATE_CD = '2023-10-31'
    AND RENYUAN_TYPE = '合计'
  GROUP BY
    DATE_CD,
    LATN_NAME
);

INSERT INTO
  COP_R_QIWEI_FAZHAN_DAY_Z
SELECT
  DATE_CD,
  '浙江分公司' LATN_NAME,
  SUM(P1.MSU_XZ_KUANDAI_QWLJ_CNT) 分子,
  SUM(P1.MSU_XZ_KUANDAI_CNT) 分母,
CASE
    WHEN SUM(P1.MSU_XZ_KUANDAI_CNT) = 0 THEN 0
    ELSE SUM(P1.MSU_XZ_KUANDAI_QWLJ_CNT) / SUM(P1.MSU_XZ_KUANDAI_CNT)
  END 企微新增宽带绑定率
FROM
  CSROP.COP_R_QIWEI_FAZHAN_DAY_Z P1
WHERE
  DATE_CD = '2023-10-31'
  AND RENYUAN_TYPE = '合计'
GROUP BY
  DATE_CD;

SELECT
  DATE_CD,
  LATN_NAME,
  分子,
  分母,
  企微新增宽带绑定率
FROM
  COP_R_QIWEI_FAZHAN_DAY_Z P1
ORDER BY
  CASE
    WHEN LATN_NAME = '浙江分公司' THEN 1
    WHEN LATN_NAME = '杭州分公司' THEN 2
    WHEN LATN_NAME = '宁波分公司' THEN 3
    WHEN LATN_NAME = '温州分公司' THEN 4
    WHEN LATN_NAME = '嘉兴分公司' THEN 5
    WHEN LATN_NAME = '湖州分公司' THEN 6
    WHEN LATN_NAME = '绍兴分公司' THEN 7
    WHEN LATN_NAME = '金华分公司' THEN 8
    WHEN LATN_NAME = '衢州分公司' THEN 9
    WHEN LATN_NAME = '丽水分公司' THEN 10
    WHEN LATN_NAME = '台州分公司' THEN 11
    WHEN LATN_NAME = '舟山分公司' THEN 12
    ELSE 99
  END;

--------------------------------------------------15.星级高套提值ARPU-------------------------------------------------------
SELECT
  P1.BIL_MONTH,
  PS.AREA_NAME,
  P1.VALUE_CNT 星级高套提值量,
  P1.VALUE_ARPU 星级高套提值ARPU
FROM
  CSRTEST.COP_R_STAR_BAG_MON_Z_ZYM P1
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
WHERE
  P1.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
  AND P1.VALUE_NAME = '高套提值'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

SELECT
  P1.BIL_MONTH,
  PS.AREA_NAME,
  P1.VALUE_CNT 星级有效绑定量,
  P1.VALUE_ARPU 星级有效绑定ARPU
FROM
  CSRTEST.COP_R_STAR_BAG_MON_Z_ZYM P1
  LEFT JOIN DMNVIEW.STD_MKTOL_AREA_TREE_NO_DEPT_Z PS ON P1.AREA_ID = PS.AREA_ID
WHERE
  P1.BIL_MONTH = TO_CHAR(
    ADD_MONTHS(TO_DATE('202310', 'YYYYMM'), -1),
    'YYYYMM'
  ) --T-2月报
  AND P1.VALUE_NAME = '有效绑定'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  CASE
    WHEN P1.AREA_ID = 1 THEN 1
    ELSE CAST(PS.ORDER_ID AS INT)
  END;

-------------------------------------------------------数据与市场部校对-----------------------------------------------------
SELECT
  P7.BIL_MONTH,
  P2.AREA_NAME,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.MON_CDMA_LOST_LV_202001
    WHEN RIGHT('202310', 2) = '02' THEN P7.MON_CDMA_LOST_LV_202002
    WHEN RIGHT('202310', 2) = '03' THEN P7.MON_CDMA_LOST_LV_202003
    WHEN RIGHT('202310', 2) = '04' THEN P7.MON_CDMA_LOST_LV_202004
    WHEN RIGHT('202310', 2) = '05' THEN P7.MON_CDMA_LOST_LV_202005
    WHEN RIGHT('202310', 2) = '06' THEN P7.MON_CDMA_LOST_LV_202006
    WHEN RIGHT('202310', 2) = '07' THEN P7.MON_CDMA_LOST_LV_202007
    WHEN RIGHT('202310', 2) = '08' THEN P7.MON_CDMA_LOST_LV_202008
    WHEN RIGHT('202310', 2) = '09' THEN P7.MON_CDMA_LOST_LV_202009
    WHEN RIGHT('202310', 2) = '10' THEN P7.MON_CDMA_LOST_LV_202010
    WHEN RIGHT('202310', 2) = '11' THEN P7.MON_CDMA_LOST_LV_202011
    WHEN RIGHT('202310', 2) = '12' THEN P7.MON_CDMA_LOST_LV_202012
    ELSE 0
  END 移动当月离网率,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.LJ_CDMA_LOST_LV_202001
    WHEN RIGHT('202310', 2) = '02' THEN P7.LJ_CDMA_LOST_LV_202002
    WHEN RIGHT('202310', 2) = '03' THEN P7.LJ_CDMA_LOST_LV_202003
    WHEN RIGHT('202310', 2) = '04' THEN P7.LJ_CDMA_LOST_LV_202004
    WHEN RIGHT('202310', 2) = '05' THEN P7.LJ_CDMA_LOST_LV_202005
    WHEN RIGHT('202310', 2) = '06' THEN P7.LJ_CDMA_LOST_LV_202006
    WHEN RIGHT('202310', 2) = '07' THEN P7.LJ_CDMA_LOST_LV_202007
    WHEN RIGHT('202310', 2) = '08' THEN P7.LJ_CDMA_LOST_LV_202008
    WHEN RIGHT('202310', 2) = '09' THEN P7.LJ_CDMA_LOST_LV_202009
    WHEN RIGHT('202310', 2) = '10' THEN P7.LJ_CDMA_LOST_LV_202010
    WHEN RIGHT('202310', 2) = '11' THEN P7.LJ_CDMA_LOST_LV_202011
    WHEN RIGHT('202310', 2) = '12' THEN P7.LJ_CDMA_LOST_LV_202012
    ELSE 0
  END 移动月均离网率,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.MON_BRD_LOST_LV_202001
    WHEN RIGHT('202310', 2) = '02' THEN P7.MON_BRD_LOST_LV_202002
    WHEN RIGHT('202310', 2) = '03' THEN P7.MON_BRD_LOST_LV_202003
    WHEN RIGHT('202310', 2) = '04' THEN P7.MON_BRD_LOST_LV_202004
    WHEN RIGHT('202310', 2) = '05' THEN P7.MON_BRD_LOST_LV_202005
    WHEN RIGHT('202310', 2) = '06' THEN P7.MON_BRD_LOST_LV_202006
    WHEN RIGHT('202310', 2) = '07' THEN P7.MON_BRD_LOST_LV_202007
    WHEN RIGHT('202310', 2) = '08' THEN P7.MON_BRD_LOST_LV_202008
    WHEN RIGHT('202310', 2) = '09' THEN P7.MON_BRD_LOST_LV_202009
    WHEN RIGHT('202310', 2) = '10' THEN P7.MON_BRD_LOST_LV_202010
    WHEN RIGHT('202310', 2) = '11' THEN P7.MON_BRD_LOST_LV_202011
    WHEN RIGHT('202310', 2) = '12' THEN P7.MON_BRD_LOST_LV_202012
    ELSE 0
  END 宽带当月离网率,
CASE
    WHEN RIGHT('202310', 2) = '01' THEN P7.LJ_BRD_LOST_LV_202001
    WHEN RIGHT('202310', 2) = '02' THEN P7.LJ_BRD_LOST_LV_202002
    WHEN RIGHT('202310', 2) = '03' THEN P7.LJ_BRD_LOST_LV_202003
    WHEN RIGHT('202310', 2) = '04' THEN P7.LJ_BRD_LOST_LV_202004
    WHEN RIGHT('202310', 2) = '05' THEN P7.LJ_BRD_LOST_LV_202005
    WHEN RIGHT('202310', 2) = '06' THEN P7.LJ_BRD_LOST_LV_202006
    WHEN RIGHT('202310', 2) = '07' THEN P7.LJ_BRD_LOST_LV_202007
    WHEN RIGHT('202310', 2) = '08' THEN P7.LJ_BRD_LOST_LV_202008
    WHEN RIGHT('202310', 2) = '09' THEN P7.LJ_BRD_LOST_LV_202009
    WHEN RIGHT('202310', 2) = '10' THEN P7.LJ_BRD_LOST_LV_202010
    WHEN RIGHT('202310', 2) = '11' THEN P7.LJ_BRD_LOST_LV_202011
    WHEN RIGHT('202310', 2) = '12' THEN P7.LJ_BRD_LOST_LV_202012
    ELSE 0
  END 宽带月均离网率
FROM
  CSROP.HEMS_A_ASSET_LOST_MON_Z P7 --B14
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P7.AREA_ID = P2.AREA_ID
WHERE
  P7.BIL_MONTH = '202310'
  AND P2.AREA_LVL IN ('2', '3')
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

-------------------------------------------------------临时更新数据-----------------------------------------------------
SELECT
  CAST(P1.AREA_ID AS INT) AREA_ID,
  P2.AREA_NAME 地市,
  P1.QUA_XHY_ALL /(DATE('2023-10-31') - DATE('2023-04-01') + 1) 小合约季度日均,
  '当季累计日均' DATE_TYPE,
  '小合约' TYPE_NAME
FROM
  CSROP.COP_R_SMALL_CONTRACT_DAY_Z P1
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.DATE_CD = '2023-10-31'
  AND P1.XHY_DATE_FLG = '当日'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

SELECT
  CAST(P1.AREA_ID AS INT) AREA_ID,
  P2.AREA_NAME 地市,
  P1.DAY_ALL_CNT 满卡,
  '当季累计日均' DATE_TYPE,
  '满卡' TYPE_NAME
FROM
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z P1
  LEFT JOIN DIM.DIM_AREA_TREE_LVL6_Z P2 ON P1.AREA_ID = P2.AREA_ID
WHERE
  P1.DATE_CD = '2023-10-31'
  AND P1.DATE_TYPE = '当季' --当周、当月、当季
  AND P1.IS_SINGLE_CUST = '总体'
  AND P1.AREA_ID IN (
    '1',
    '2',
    '3',
    '4',
    '5',
    '9',
    '32518',
    '7',
    '12',
    '10',
    '8',
    '11'
  )
ORDER BY
  P2.AREA_LVL,
  CAST(P2.ORDER_ID AS INT);

------------------------------------------------------------------------------分渠道------------------------------------------------------------------------------
-----------------------------分渠道NEW
-- 实体渠道+装维渠道 = 实体渠道总
-- 当月累计日均
SELECT
  LATN_ID,
  CHANNEL_DEPT_NAME_2014 渠道,
  UP5_CNT A4升5新增,
  XHY_CNT 小合约新增,
  TSYB_CNT 宽带收费包,
  CL_WIFI_CNT 存量WIFI加装,
  MK_CNT 满卡,
  YYTZ5G_CNT A5G运营提值,
  ZDXYW_CNT 重点小业务,
  CLCG_CNT 存量重耕,
  BING_EFF_CNT 套餐有效绑定,
  DATE_CD
FROM
  CSROP.COP_R_CHANNEL_DAY_Z
WHERE
  INDEX_DATE = '当月'
  AND CHANNEL_FLG = '总体'
  AND DATE_CD = '2023-10-31'
  AND AREA_LEVEL IN ('2')
ORDER BY
  CASE
    WHEN CHANNEL_DEPT_NAME_2014 = '总体' THEN 1
    WHEN CHANNEL_DEPT_NAME_2014 = '实体渠道部门' THEN 2
    WHEN CHANNEL_DEPT_NAME_2014 = '装维渠道部门' THEN 3
    WHEN CHANNEL_DEPT_NAME_2014 = '装维渠道' THEN 4
    WHEN CHANNEL_DEPT_NAME_2014 = '政企渠道部门' THEN 5
    WHEN CHANNEL_DEPT_NAME_2014 = '电子渠道部门' THEN 6
    WHEN CHANNEL_DEPT_NAME_2014 = '其他' THEN 7
    ELSE 99
  END;

-------------------------电子渠道NEW
SELECT
  DATE_CD,
  BRD_BAG_STAR_CNT,
  BRD_BAG_WH_CNT -- ,BRD_BAG_XSYY_CNT  
  -- ,BRD_BAG_XSTZ_CNT 
,
  BRD_BAG_XS_CNT,
  BRD_BAG_WANHAO_CNT,
  CLCG_STAR_VALUE,
  CLCG_WH_VALUE,
  CLCG_XS_VALUE,
  CLCG_WANHAO_VALUE,
  SMALL_CON_XS_CNT 线上小合约日均户数
FROM
  CSROP.COP_R_DZ_CHANNEL_DAY_Z
WHERE
  DATE_CD = '2023-10-31'
  AND TIME_TYPE = '当月'
  AND DATA_TYPE = '日均'
  AND AREA_ID = 1;

-----------------------------以下为历史使用数据，已淘汰
--3+X模型
SELECT
  '202310' BIL_MONTH,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包总体,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG IN ('营业', '装维') THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包实体,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '营业' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包营业,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '装维' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包装维,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '政企' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包政企,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG IN ('线上', '星级', '外呼', '万号') THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包电子,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '万号' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包万号,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '外呼' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包外呼,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '星级' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包星级,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '线上' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包线上,
  SUM(
    CASE
      WHEN YW_TYPE = '宽带收费月包'
      AND QD_FLG = '其他' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 宽带收费月包其他
FROM
  CSROP.CSR_A_RH_RB_DAY_Z
WHERE
  DATE_CD >= '2023-07-01'
  AND DATE_CD <= '2023-10-31';

SELECT
  '202310' BIL_MONTH,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕总体,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG IN ('营业', '装维') THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕实体,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '营业' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕营业,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '装维' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕装维,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '政企' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕政企,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG IN ('线上', '星级', '外呼', '万号') THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕电子,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '万号' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕万号,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '外呼' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕外呼,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '星级' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕星级,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '线上' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕线上,
  SUM(
    CASE
      WHEN YW_TYPE = '存量重耕'
      AND QD_FLG = '其他' THEN 1
      ELSE 0
    END
  ) / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 存量重耕其他
FROM
  CSROP.CSR_A_RH_RB_DAY_Z
WHERE
  DATE_CD >= '2023-07-01'
  AND DATE_CD <= '2023-10-31';

--小合约专项日报
SELECT
  QUA_ALL_XHY_ST 季度实体,
  QUA_ALL_XHY_ZW 季度装维,
  QUA_ALL_XHY_ZQ 季度政企,
  QUA_ALL_XHY_DZ 季度电子,
  MON_ALL_XHY_ST / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 月实体,
  MON_ALL_XHY_ZW / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 月装维,
  MON_ALL_XHY_ZQ / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 月政企,
  MON_ALL_XHY_DZ / TO_CHAR(LAST_DAY(TO_DATE('202310', 'YYYYMM')), 'DD') 月电子,
  DATE_CD
FROM
  CSROP.COP_R_SMALL_CONTRACT_DAY_Z --小合约专项日报
WHERE
  DATE_CD = '2023-10-31'
  AND AREA_ID = 1
  AND XHY_DATE_FLG = '当日';

--4升5价值变化月报
SELECT
  CL_ARPU 存量总体ARPU,
  ST_ARPU 实体ARPU,
  ST_ZW_ARPU 实体装维ARPU,
  ZQ_ARPU 政企ARPU,
  DZ_ARPU 电子ARPU,
  DZ_XSYY_ARPU 线上运营ARPU,
  DZ_XJ_ARPU 星级ARPU,
  DZ_WH_ARPU 外呼ARPU,
  DZ_XSTZ_ARPU 线上拓展ARPU,
  DZ_WANHAO_ARPU 万号ARPU
FROM
  CSROP.HEMS_R_4UP5G_VALUE_MON_Z --4升5价值变化月报
WHERE
  BIL_MONTH = '202306'
  AND CORP_USER_NAME = '总体'
  AND AREA_ID = 1;

-- 4升5 营业、线上ARPU
CREATE LOCAL TEMPORARY TABLE LIST_Z_4UP5 ON COMMIT PRESERVE ROWS AS(
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_A P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_B P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_C P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_D P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_E P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_F P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_G P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_H P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_I P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_J P1
  WHERE
    BIL_MONTH = '202306'
  UNION
  ALL
  SELECT
    P1.*
  FROM
    CSROP.HEMS_A_4UP5G_VALUE_LIST_K P1
  WHERE
    BIL_MONTH = '202306'
);

SELECT
  BIL_MONTH,
CASE
    WHEN COUNT(
      CASE
        WHEN PROM_BAG_TYPE != '全新套餐'
        AND CHANNEL_DEPT_NAME_2014 = '电子'
        AND DZ_FLG NOT IN ('星级', '外呼', '万号') THEN PROM_ASSET_INTEG_ID
      END
    ) = 0 THEN 0
    ELSE SUM(
      CASE
        WHEN PROM_BAG_TYPE != '全新套餐'
        AND CHANNEL_DEPT_NAME_2014 = '电子'
        AND DZ_FLG NOT IN ('星级', '外呼', '万号') THEN AMT_CHG
      END
    ) / COUNT(
      CASE
        WHEN PROM_BAG_TYPE != '全新套餐'
        AND CHANNEL_DEPT_NAME_2014 = '电子'
        AND DZ_FLG NOT IN ('星级', '外呼', '万号') THEN PROM_ASSET_INTEG_ID
      END
    )
  END XS_ARPU,
CASE
    WHEN COUNT(
      CASE
        WHEN PROM_BAG_TYPE != '全新套餐'
        AND CHANNEL_DEPT_NAME_2014 = '实体'
        AND DZ_FLG NOT IN ('社区经理', '装维经理') THEN PROM_ASSET_INTEG_ID
      END
    ) = 0 THEN 0
    ELSE SUM(
      CASE
        WHEN PROM_BAG_TYPE != '全新套餐'
        AND CHANNEL_DEPT_NAME_2014 = '实体'
        AND DZ_FLG NOT IN ('社区经理', '装维经理') THEN AMT_CHG
      END
    ) / COUNT(
      CASE
        WHEN PROM_BAG_TYPE != '全新套餐'
        AND CHANNEL_DEPT_NAME_2014 = '实体'
        AND DZ_FLG NOT IN ('社区经理', '装维经理') THEN PROM_ASSET_INTEG_ID
      END
    )
  END YY_ARPU --营业ARPU
FROM
  LIST_Z_4UP5
GROUP BY
  BIL_MONTH;

-- 客户经营积分
SELECT
  CHANNEL_DEPT_NAME_2014,
  ALL_SCORE / 10000 / 31
FROM
  CSROP.COP_R_SCORE_DAY_TB_MON_Z
WHERE
  DZ_CHANNEL_FLG = '总体'
  AND AREA_LEVEL IN ('2')
  AND BIL_MONTH = '202310'
  AND CCUST_FLG = '存量客户'
ORDER BY
  CHANNEL_DEPT_NAME_2014;

--电子渠道分版块统计表
SELECT
  DATE_CD,
  SMALL_CON_WANHAO_CNT,
  SMALL_CON_WH_CNT,
  SMALL_CON_STAR_CNT -- ,SMALL_CON_XSYY_CNT  
  -- ,SMALL_CON_XSTZ_CNT   
,
  SMALL_CON_XS_CNT,
  UP5_WANHAO_CNT,
  UP5_WH_CNT,
  UP5_STAR_CNT -- ,UP5_XSYY_CNT    
  -- ,UP5_XSTZ_CNT
,
  UP5_XS_CNT,
  YY5G_WANHAO_VALUE,
  YY5G_WH_VALUE,
  YY5G_STAR_VALUE -- ,YY5G_XSYY_VALUE    
  -- ,YY5G_XSTZ_VALUE  
,
  YY5G_XS_VALUE,
  BRD_BAG_WANHAO_CNT,
  BRD_BAG_WH_CNT,
  BRD_BAG_STAR_CNT -- ,BRD_BAG_XSYY_CNT  
  -- ,BRD_BAG_XSTZ_CNT 
,
  BRD_BAG_XS_CNT,
  ZDXYW_WANHAO_CNT,
  ZDXYW_WH_CNT,
  ZDXYW_STAR_CNT -- ,ZDXYW_XSYY_CNT
  -- ,ZDXYW_XSTZ_CNT
,
  ZDXYW_XS_CNT,
  QWWF_WANHAO_CNT,
  QWWF_WH_CNT,
  QWWF_STAR_CNT -- ,QWWF_XSYY_CNT    
  -- ,QWWF_XSTZ_CNT     
,
  QWWF_XS_CNT,
  MK_WANHAO_CNT,
  MK_WH_CNT,
  MK_STAR_CNT -- ,MK_XSYY_CNT    
  -- ,MK_XSTZ_CNT                         
,
  MK_XS_CNT,
  CLCG_WANHAO_VALUE,
  CLCG_WH_VALUE,
  CLCG_STAR_VALUE,
  CLCG_XS_VALUE,
  BIND_WANHAO_CNT,
  BIND_WH_CNT,
  BIND_STAR_CNT -- ,BIND_XSYY_CNT    
  -- ,BIND_XSTZ_CNT                         
,
  BIND_XS_CNT
FROM
  CSROP.COP_R_DZ_CHANNEL_DAY_Z
WHERE
  DATE_CD = '2023-10-31'
  AND TIME_TYPE = '当月'
  AND DATA_TYPE = '日均'
  AND AREA_ID = 1;