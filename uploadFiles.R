dir = "~/Downloads"
files = list.files(dir, full.names=TRUE, pattern="^USA_CA_.*")
wea = list.files(files, full.names=TRUE, pattern=".wea")
pvsyst = list.files(files, full.names=TRUE, pattern=".pvsyst")
stat = list.files(files, full.names=TRUE, pattern=".stat")

