library(data.table)
library(ggplot2)
library(tidyr)

genBox = function(dt, task_id = NULL, dname, resample_name, kickout = NULL, fsave = F) {
  library(hrbrthemes)
  library(ggplot2)
  checkmate::assert(all(c("lrn", "algo", "bag", "openbox", "lockbox", "curator") %in% colnames(dt)))
  if (!is.null(kickout)) dt = dt[with(dt, !(algo %in% kickout)), ]
  dtl = tidyr::gather(dt, key = box, value = mmce, openbox, lockbox, curator)
  #fig = ggplot2::ggplot(dtl, aes(x = algo, y = mmce, fill = bag)) + geom_violin(draw_quantiles = c(0.25, 0.5, 0.75), adjust = .5, scale = "count") + facet_grid(rows = vars(lrn), cols = vars(box)) +  theme(axis.text.x = element_text(angle = 90, hjust = 1), plot.title = element_text(hjust = 0.5)) + theme_bw() + scale_fill_ipsum()
  #fig = ggplot2::ggplot(dtl, aes(x = algo, y = mmce, fill = bag)) + geom_boxplot() + facet_grid(rows = vars(lrn), cols = vars(box)) +  theme(axis.text.x = element_text(angle = 90, hjust = 1), plot.title = element_text(hjust = 0.5)) + theme_bw() + scale_fill_ipsum()
  fig = ggplot2::ggplot(dtl, aes(x = box, y = mmce, fill = bag)) + geom_boxplot() + facet_grid(rows = vars(lrn), cols = vars(algo)) +  theme(axis.text.x = element_text(angle = 90, hjust = 1), plot.title = element_text(hjust = 0.5)) + theme_bw() + scale_fill_ipsum()
 
 
  #+ ggtitle("comparison of mmce across learner and data site on geo dataset")
  if (fsave) ggsave(sprintf("boxplot_%s_%s_%s.pdf", dname, task_id, resample_name), plot = fig)
  fig
}

  # 14966 bioresponse
  # 3891 gina-agnostic
  # 9950 micro-mass  (20 classes)
  # 3608: fri_c4_500_100
  # 9981 cnae-9 (9 class to 2 class)
 


dt = readRDS("dt_res_oml_jan29.rds")
dt = readRDS("dt_lambdaJan31.rds")
dt = readRDS("dt_res_geo_response.rds")
dt = readRDS("dt_3608_pca1.rds")
dtladder = readRDS("dt_alpha_ladder_feb18_lowdim.rds")
dtladder = readRDS("dt_alpha_ladder_feb14.rds")
colnames(dtladder)


dt = readRDS("dt_3608_stratif.rds")
dtladder = dtladder[dtladder$prob == "prob_oml_stratif"]
dtladder = dtladder[dtladder$dsna == "oml_t_3608"]


dt = readRDS("dt_3891_stratif.rds")
dtladder = dtladder[dtladder$dsna == "oml_t_3891"]
dtladder = dtladder[dtladder$prob == "prob_oml_stratif"]

dt = readRDS("dt_10101_stratif.rds")
dtladder = dtladder[dtladder$dsna == "oml_t_10101"]
dtladder = dtladder[dtladder$prob == "prob_oml_stratif"]



dtc = rbindlist(list(dt, dtladder), use.names = T, fill = T)

#dt2 = dt[(openbox_name=="GSE16446") & (lockbox_name=="GSE20194"),]


genBox(dtc, task_id = "", dname = "geo", resample_name = "")

genBox(dtladder, task_id = "", dname = "geo", resample_name = "", kickout = c("fso_th", "fso_ladder") )
genBox(dt, task_id = "", dname = "geo", resample_name = "", kickout = c("fso_th", "fso_ladder") )
genBox(dt, task_id = "", dname = "geo", resample_name = "", kickout = c("fso_ladder") )


genBox2 = function(dt, task_id = NULL, dname, resample_name, kickout = NULL) {
  library(hrbrthemes)
  checkmate::assert(all(c("lrn", "algo", "bag", "openbox", "lockbox", "curator") %in% colnames(dt)))
  library(tidyr)
  library(dplyr)
  library(data.table)
  if(!is.null(kickout)) dt = dt[with(dt, !(algo %in% kickout)), ]
  dtl = tidyr::gather(dt, key = box, value = mmce, openbox, lockbox, curator)
  dtl = as.data.table(dtl)
  func = function(x) {
    worst = max(x)
    x/worst
  }
  dtl = dtl[, mmce:=func(mmce), by = c("openbox_name", "lockbox_name", "lrn")]
  fig = ggplot2::ggplot(dtl, aes(x = algo, y = mmce, fill = bag)) + geom_boxplot() + facet_grid(rows = vars(lrn), cols = vars(box)) +  theme(axis.text.x = element_text(angle = 90, hjust = 1), plot.title = element_text(hjust = 0.5)) + theme_bw() + scale_fill_ipsum()
  #+ ggtitle("comparison of mmce across learner and data site on geo dataset")
  ggsave(sprintf("boxplot_%s_%s_%s.pdf", dname, task_id, resample_name), plot = fig)
  fig
}



genBox2(dt, task_id = 31, dname = "oml", resample_name = "stratif", kickout = c("fso_th", "fso_ladder") )
genBox2(dt, task_id = 31, dname = "oml", resample_name = "stratif", kickout = c("fso_ladder"))
