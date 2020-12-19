cd /content/darknet

mkdir ./predictions
mkdir ./predictions/Neutral
mkdir ./predictions/Fire
mkdir ./predictions/Smoke
mkdir ./predictions/Train
mkdir ./predictions/Train/Fire
mkdir ./predictions/Train/Smoke

for file in /content/darknet/data/obj/*.jpg

do
	echo "file: ${file}"

	/content/darknet/darknet detector test data/obj.data cfg/yolov4.cfg ../yolov4_5000.weights ${file} -iou_thresh 0.3 -thresh 0.05
     
	COUNTER_FIRE=0
	COUNTER_SMOKE=0

	var="${file%.jpg}"
  	new_prefix="${var##*/}"

	for file_prediction_fire in ./*Fire.jpg;
	do
		if [[ $file_prediction_fire != "./*Fire.jpg" ]]; then
			COUNTER_FIRE=$(( COUNTER_FIRE + 1 ))
			echo "Fire: ${file_prediction_fire}"
			no_prefix_name="${file_prediction_fire##*/}"
			mv ${file_prediction_fire} ./predictions/Train/Fire/${new_prefix}_${no_prefix_name}
		fi
	done

	for file_prediction_smoke in ./*Smoke.jpg;
	do
		if [[ $file_prediction_smoke != "./*Smoke.jpg" ]]; then
			COUNTER_SMOKE=$(( COUNTER_SMOKE + 1 ))
			echo "Smoke: ${file_prediction_smoke}"
			no_prefix_name="${file_prediction_smoke##*/}"
			mv ${file_prediction_smoke} ./predictions/Train/Smoke/${new_prefix}_${no_prefix_name}
		fi
	done

	echo "Fire Counter: ${COUNTER_FIRE}"
	echo "Smoke Counter: ${COUNTER_SMOKE}"
	
	if [[ $COUNTER_FIRE -ne 0 ]]; then
		no_prefix_name="${file##*/}"
		echo "${no_prefix_name}"
		cp ${file} ./predictions/Fire/${no_prefix_name}
	else
		if [[ $COUNTER_SMOKE -eq 0 ]];
		then
			no_prefix_name="${file##*/}"
			echo "${no_prefix_name}"
			cp ${file} ./predictions/Neutral/${no_prefix_name}
		else
			no_prefix_name="${file##*/}"
			echo "${no_prefix_name}"
			cp ${file} ./predictions/Smoke/${no_prefix_name}
		fi
	fi
done

