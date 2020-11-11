#/bin/bash

mkdir ./predicitons
mkdir ./predicitons/Fire
mkdir ./predicitons/Smoke

for file in /content/darknet/data/obj/*.jpg

do
	/content/darknet/darknet detector test data/obj.data cfg/yolov4.cfg ../yolov4_5000.weights ${file} -iou_thresh 0.3 -thresh 0.05

	var="${file%.jpg}"
  	new_prefix="${var##*/}"

	for file_prediction_fire in ./*Fire.jpg
	do		
		#echo "${file_prediction_fire}"
		no_prefix_name="${file_prediction_fire##*/}"
		mv ${file_prediction_fire} ./predicitons/Fire/${new_prefix}_${no_prefix_name}
	done

	for file_prediction_smoke in ./*Smoke.jpg
	do
		#echo "${file_prediction_smoke}"
		no_prefix_name="${file_prediction_smoke##*/}"
		mv ${file_prediction_smoke} ./predicitons/Smoke/${new_prefix}_${no_prefix_name}
	done
done

