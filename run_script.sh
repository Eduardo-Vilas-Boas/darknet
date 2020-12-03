#/bin/bash

mkdir ./predictions
mkdir ./predictions/Neutral
mkdir ./predictions/Fire
mkdir ./predictions/Smoke

for file in /content/darknet/data/obj/*.jpg

do
	/content/darknet/darknet detector test data/obj.data cfg/yolov4.cfg ../yolov4_5000.weights ${file} -iou_thresh 0.3 -thresh 0.05

	var="${file%.jpg}"
  	new_prefix="${var##*/}"

	FILE_FIRE=./*Fire.jpg
	FILE_SMOKE=./*Smoke.jpg	

	if test -f "$FILE_FIRE"; then
		no_prefix_name="${file##*/}"
	else
		if test -f "$FILE_SMOKE"; then
		else
			no_prefix_name="${file##*/}"
			mv ${file} ./predictions/Neutral/${no_prefix_name}
		fi
	fi


	for file_prediction_fire in ./*Fire.jpg
	do		
		#echo "${file_prediction_fire}"
		no_prefix_name="${file_prediction_fire##*/}"
		mv ${file_prediction_fire} ./predictions/Fire/${new_prefix}_${no_prefix_name}
	done

	for file_prediction_smoke in ./*Smoke.jpg
	do
		#echo "${file_prediction_smoke}"
		no_prefix_name="${file_prediction_smoke##*/}"
		mv ${file_prediction_smoke} ./predictions/Smoke/${new_prefix}_${no_prefix_name}
	done
done

