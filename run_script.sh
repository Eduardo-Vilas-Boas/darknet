#/bin/bash

for file in ./obj/*.jpg
do
	/content/darknet/darknet detector test data/obj.data cfg/yolov4.cfg ../yolov4_5000.weights ${file} -iou_thresh 0.3 -thresh 0.05

	mkdir "${file%.jpg}"

	cp ./*Fire.jpg /"${file%.jpg}"
	cp ./*Smoke.jpg /"${file%.jpg}"
done

