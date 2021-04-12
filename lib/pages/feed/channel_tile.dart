import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:twake/blocs/draft_bloc/draft_bloc.dart';
import 'package:twake/blocs/profile_bloc/profile_bloc.dart';
import 'package:twake/config/dimensions_config.dart';
import 'package:twake/repositories/draft_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/utils/dateformatter.dart';
import 'package:twake/utils/navigation.dart';
import 'package:twake/widgets/common/channel_title.dart';
import 'package:twake/widgets/common/text_avatar.dart';

class ChannelTile extends StatelessWidget {
  final String id;
  final String name;
  final String icon;
  final bool hasUnread;
  final bool isPrivate;
  final int lastActivity;
  final int messagesUnread;
  final Map<String, dynamic> lastMessage;

  const ChannelTile({
    Key key,
    this.id,
    this.name,
    this.icon,
    this.hasUnread,
    this.isPrivate,
    this.lastActivity,
    this.messagesUnread,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var draftType = DraftType.channel;
        // Load draft from local storage
        context.read<DraftBloc>().add(LoadDraft(id: id, type: draftType));
        openChannel(context, id);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 12.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ChannelThumbnail(
              icon: icon,
              isPrivate: isPrivate,
            ),
            SizedBox(width: 11.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ChannelTitle(
                          name: name,
                          hasUnread: hasUnread,
                          isPrivate: false,
                        ),
                      ),
                      Text(
                        DateFormatter.getVerboseDateTime(lastActivity),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            lastMessage['text'] ?? 'No messages yet',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      if (messagesUnread != 0) SizedBox(width: Dim.wm2),
                      // if (channel.messagesUnread != 0)
                      BlocBuilder<ProfileBloc, ProfileState>(
                        buildWhen: (_, current) => current is ProfileLoaded,
                        builder: (_, state) {
                          if (state is ProfileLoaded) {
                            final count = state.getBadgeForChannel(id);
                            if (count > 0) {
                              return Badge(
                                shape: BadgeShape.square,
                                badgeColor: Color(0xff004dff),
                                elevation: 0,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.5),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                badgeContent: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelThumbnail extends StatelessWidget {
  final String icon;
  final bool isPrivate;

  const ChannelThumbnail({
    Key key,
    this.icon,
    this.isPrivate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 60.0,
          height: 60.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xfff5f5f5),
          ),
          child: TextAvatar(icon),
        ),
        if (isPrivate) Image.asset('assets/images/private.png'),
      ],
    );
  }
}
