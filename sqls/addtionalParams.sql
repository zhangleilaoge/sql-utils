---------------------------------------清单测试表----------------------------------------------
--是否开通亲情网
ALTER TABLE
  CSRTEST.HEMS_A_MKXD_ZXTB_LIST_ZYM_A
ADD
  QQW_FLG INT;

---------------------------------------清单正式表VE----------------------------------------------
ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_A
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_B
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_C
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_D
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_E
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_F
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_G
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_H
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_I
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_J
ADD
  QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_K
ADD
  QQW_FLG INT;

---------------------------------------清单正式表SR----------------------------------------------
ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_A
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_B
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_C
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_D
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_E
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_F
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_G
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_H
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_I
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_J
ADD
  COLUMN QQW_FLG INT;

ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_K
ADD
  COLUMN QQW_FLG INT;

---------------------------------------清单正式表SR-视图----------------------------------------------
ALTER TABLE
  CSROP.HEMS_A_MKXD_ZXTB_LIST_Z
ADD
  COLUMN QQW_FLG INT;

---------------------------------------日报测试表已加-----------------------------------------------------
ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_CL_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_CL_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_CL_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_CL_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_CL_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_N_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_N_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_N_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_N_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T00_N_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_CL_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_CL_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_CL_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_CL_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_CL_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_N_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_N_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_N_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_N_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  T000_N_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
ADD
  DAY_QQW_CNT NUMERIC(18, 6);

---------------------------------------日报正式表VE---------------------------------------------------
ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_CL_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_CL_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_CL_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_CL_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_CL_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_N_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_N_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_N_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_N_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T00_N_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_CL_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_CL_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_CL_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_CL_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_CL_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_N_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_N_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_N_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_N_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  T000_N_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  DAY_QQW_CNT NUMERIC(18, 6);

---------------------------------------日报正式表SR---------------------------------------------------
ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_CL_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_CL_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_CL_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_CL_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_CL_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_N_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_N_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_N_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_N_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T00_N_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_CL_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_CL_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_CL_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_CL_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_CL_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_N_FK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_N_T1_CK_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_N_T1_CK_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_N_T1_ACT_CNT NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN T000_N_T1_ACT_LV NUMERIC(18, 6);

ALTER TABLE
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
ADD
  COLUMN DAY_QQW_CNT NUMERIC(18, 6);

SELECT
  *
FROM
  CSRTEST.HEMS_R_MKXD_ZXTB_NEW_DAY_Z_ZYM
WHERE
  DATE_CD = '2023-11-01'
  AND AREA_ID = 1
ORDER BY
  DATE_TYPE,
  IS_SINGLE_CUST;

SELECT
  *
FROM
  CSROP.HEMS_R_MKXD_ZXTB_NEW_DAY_Z
WHERE
  DATE_CD = '2023-11-01'
  AND AREA_ID = 1
ORDER BY
  DATE_TYPE,
  IS_SINGLE_CUST;