#palmtag data

setwd("/Users/laraoxley/Desktop/data/netcdf_palmtag")
install.packages("ncdf4")
install.packages("CFtime")
install.packages("lattice")
install.packages("RColorBrewer")
library(ncdf4)
library(CFtime)
library(lattice)
library(RColorBrewer)

ncpath <- "/Users/laraoxley/Desktop/data/netcdf_palmtag/"
ncname <- "SOC_TN_01deg.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname<-"TN"

ncin <- nc_open(ncfname)
print(ncin)
#two variables: total Nitrogen in first three meters; 
#and total soil organic carbon in first three meters;
#with two dimensions: longitude and latitude; 

# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)
print(c(nlon,nlat)) #number of longitude and latitude samples

#get total N
TN_array<-ncvar_get(ncin, "TN")
TNname<-ncatt_get(ncin,"TN","long_name")
TNunits<-ncatt_get(ncin,"TN","units")
TNunits$value<-"kgN*m-2"
fillvalue<-ncatt_get(ncin,"TN","_FillValue")
dim(TN_array)

#get soil organic carbon
SOC_array<-ncvar_get(ncin, "SOC")
SOCname<-ncatt_get(ncin,"SOC","long_name")
SOCunits<-ncatt_get(ncin,"SOC","units")
SOCunits$value<-"kgC*m-2"
fillvalue<-ncatt_get(ncin,"SOC","_FillValue")
dim(SOC_array)

# replace netCDF fill values with NA's
TN_array[TN_array==fillvalue$value] <- NA
SOC_array[SOC_array==fillvalue$value] <- NA

#create a dataframe
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)
#vector of TN values
TN_vec<-as.vector(TN_array)
length(TN_vec)

# create dataframe and add names
m<-1
TN_df01 <- data.frame(cbind(lonlat,TN_vec))
names(TN_df01) <- c("lon","lat",paste(dname,as.character(m), sep="_"))
head(na.omit(TN_df01), 10)

image(lon,lat,TN_df01, col=c(rgb(1,1,1),brewer.pal(9,"Blues")) )
