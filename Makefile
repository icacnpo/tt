


qr_pngS:=                        \
	docs/self.png                \
	docs/zftd_streamyard.png     \
	docs/zftd_mail.png           \
	docs/zftd_james_mail.png     \
	docs/james_yt.png 			 \
	docs/zftd_youtube.png

qrencodeH := qrencode    --level=high   --8bit --size=30
qrencodeL := qrencode    --level=lowest --8bit --size=30

all: $(qr_pngS) mp4
	sed -i -e \
		"/aaabbbccc01/ s;aaabbbccc01.*$$;aaabbbccc01\" href=\"`cat zftd_streamyard.txt|head -n 1`\">`cat zftd_streamyard.txt|head -n 1`</a></div>;g"  \
		docs/index.html

self_link:=https://time.chinadsf.org/
docs/self.png : self_png.txt
	$(qrencodeH)    `cat $<` -o $@
	convert \
		$@ \
		-resize 150x150 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@.150x150.forYoutube.png
	convert \
		$@ \
		-resize 384x384 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@.288x288.forYoutube.png
	convert \
		$@.288x288.forYoutube.png \
		-crop 341x384+21+0 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@.512x576.forYoutube.png 
	montage -tile 6x -borderwidth 0 -geometry +0+0 \
		$@.512x576.forYoutube.png $@.512x576.forYoutube.png $@.512x576.forYoutube.png  \
		$@.512x576.forYoutube.png $@.512x576.forYoutube.png $@.512x576.forYoutube.png  \
		$@.512x576.forYoutube.png $@.512x576.forYoutube.png $@.512x576.forYoutube.png  \
		$@.512x576.forYoutube.png $@.512x576.forYoutube.png $@.512x576.forYoutube.png  \
		$@.512x576.forYoutube.png $@.512x576.forYoutube.png $@.512x576.forYoutube.png  \
		$@.512x576.forYoutube.png $@.512x576.forYoutube.png $@.512x576.forYoutube.png  \
		-resize 2048 \
		-crop 2048x1152 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@.2048x1152.forYoutube.png 
	$(qrencodeL)    `cat $<` -o $@.L.png
	convert \
		$@.L.png \
		-resize 170x170 \
		-crop   150x150+10+10 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@.150x150.forYoutube.L.png
	convert \
		$@.L.png \
		-resize 340x340 \
		-crop   300x300+20+20 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@.300x300.forYoutube.L.png
		

docs/james_yt.png : james_yt.txt
	$(qrencodeH)    `cat $<` -o $@

docs/zftd_youtube.png : zftd_youtube.txt
	$(qrencodeH)    `cat $<` -o $@

docs/zftd_mail.png : zftd_mail.txt
	$(qrencodeH)    `cat $<` -o $@

docs/zftd_james_mail.png : zftd_james_mail.txt
	$(qrencodeH)    `cat $<` -o $@

docs/zftd_streamyard.png : zftd_streamyard.txt
	$(qrencodeH)    `cat $<` -o $@


s2 :
	cd docs/ && python3 -m http.server 33221

gs:
	nice -n 17 git status

gc:
	nice -n 17 git commit -a

up:
	pwd
	nice -n 17 git push -u origin master


gcXmmm:=$(shell (LC_ALL=C date +"%Y%m%d_%H%M%p" ; cat /etc/timezone )|tr "/\r\n-" _)
gcX:
	nice -n 17 git commit -m $(gcXmmm)


ga :
	nice -n 17 git add .
gd :
	nice -n 17 git diff

m:
	vim Makefile

X: ga gcX up

s3 :
	 cd docs && python3 -m http.server 33223
s4 :
	 python3 -m http.server 33224

define myString01
`aa1=$$(echo $1|tr '/.' _);echo $${!aa1}`
endef




define myFuncCombinePng2
$$(eval export X$1=$$(shell echo $1|tr '/.' _))
$$(eval export Y$1=$$($$(X$1)))
$1: $$(Y$1)
$1:
	convert $$(Y$1) +append $1
clear_objs01 += $1
endef

export mp4_mp41_png := mp4/mp411.640x720.png mp4/mp412.640x720.png 
export mp4_mp43_png := mp4/mp411.640x720.png mp4/mp413.640x720.png 
mp4_pngset:=mp4/mp41.png mp4/mp43.png
$(foreach aa1,$(mp4_pngset),$(eval $(call myFuncCombinePng2,$(aa1))))



export mp4_mp412_640x720_png := mp412.xelatex
export mp4_mp413_640x720_png := mp413.xelatex
mp4/mp412.640x720.png : mp412.xelatex
mp4/mp413.640x720.png : mp413.xelatex
mp4/mp412.640x720.png   mp4/mp413.640x720.png :
	mkdir -p tmp/
	cd tmp && rm -f $(basename $(notdir $<)).*
	cd tmp && xelatex ../$<
	cd tmp && \
		nice -n 19   pdftoppm -r 300       -png     \
		$(basename $(notdir $<)).pdf \
		$(basename $(notdir $<))
	cd tmp && \
		convert \
		$(basename $(notdir $<))-1.png  \
		-resize 640x720 \
		-extent 640x720 \
		ppm:- | pnmdepth 16 | pnmtopng > \
		../mp4/$(basename $(notdir $<)).640x720.png \

#mp4/mp411.640x720.png  : docs/zftd_streamyard.png
mp4/mp411.640x720.png  : docs/self.png
	convert \
		$< \
		-resize 640x720 \
		-extent 640x720 \
		ppm:- | pnmdepth 1 | pnmtopng > \
		$@




# mp4/mp41.mp4   mp4/mp43.mp4 : 
# 	rm -f $@
# 	ffmpeg -loop 1 -i \
# 		$(call myString01,$@)    \
# 		-c:v libx264 \
# 		-t 90 \
# 		-pix_fmt yuv420p \
# 		-vf scale=1280:720 \
# 		$@
# 	cp \
# 		$@ \
# 		~/Downloads/




define myFunGenMp4
#mp4 : $1 kkkk
$$(eval export MX$1=$$(shell echo $1|tr '/.' _))
$$(eval export MY$1=$$($$(MX$1)))
$1: $$(MY$1)
$1:
	echo convert... $$(MY$1) +append $1
	rm -f $1
	ffmpeg -loop 1 -i \
		$$(MY$1)    \
		-c:v libx264 \
		-t 90 \
		-pix_fmt yuv420p \
		-vf scale=1280:720 \
		$1
	cp \
		$1 \
		~/Downloads/
clear_objs01 += $1
mp4 : $1

endef


export mp4_mp41_mp4 := mp4/mp41.png 
export mp4_mp43_mp4 := mp4/mp43.png 
mp4 := mp4/mp41.mp4 mp4/mp43.mp4 
$(foreach aa1,$(mp4),$(eval $(call myFunGenMp4,$(aa1))))

c clean_mp4_objs :
	rm -f $(clear_objs01)

